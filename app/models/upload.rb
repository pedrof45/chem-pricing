class Upload < ApplicationRecord
  extend Enumerize
  belongs_to :user
  attr_accessor :file, :records

  after_validation :parse
  after_create :associate_records, :update_watched_quotes

  validates_presence_of :model, :file, :user
  validate :granted_model

  enumerize :model, in: [:quote,:optimal_markup, :sale, :cost, :customer, :product, :icms_tax, :city,
                         :normal_bulk_freight, :chopped_bulk_freight, :product_bulk_freight, :especial_packed_freight, :normal_packed_freight, :vehicle, :packaging]

  def name
    "id: #{id}"
  end

  def granted_model
    return unless model
    errors.add(:model, "Não autorizado") unless Upload.granted_models_for(user.role).include? model.to_sym
  end

  def self.granted_models_for(role)
    if role == :agent || role== :manager
      [:quote]
    else
      self.model.values
    end
  end

  def klass
    Object.const_get model.to_s.classify
  end

  def pt_model
    I18n.t("activerecord.models.#{model}.other") if model
  end

  def parse
    unless file.blank?
      if file.respond_to?(:read)
        UploadParserService.new(u: self).run unless file.blank?
      else
        errors.add(:file, "Não é possível ler o arquivo") and return
      end
    end

  rescue StandardError => e
    errors.add(:file, "Erro: #{e}")
  end

  def associate_records
    klass.where(id: records).update_all(upload_id: self.id)
  end

  def update_watched_quotes
    return unless model == 'cost'# || model.include?('freight')
    WatchedUpdateJob.perform_later('upload', id)
  end

  def records_count
    klass.where(upload_id: self.id).count
  end
end

# == Schema Information
#
# Table name: uploads
#
#  id         :integer          not null, primary key
#  filename   :string
#  model      :string
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_uploads_on_user_id  (user_id)
#
