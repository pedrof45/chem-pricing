class Upload < ApplicationRecord
  extend Enumerize
  belongs_to :user
  attr_accessor :file

  after_validation :parse

  validates_presence_of :model, :file, :user
  validate :granted_model

  enumerize :model, in: [:quote,:optimal_markup, :sale, :cost, :customer, :product, :icms_tax, :city,
                         :normal_bulk_freight, :chopped_bulk_freight, :product_bulk_freight, :especial_packed_freight, :normal_packed_freight, :vehicle, :packaging]

  def granted_model
    errors.add(:model, "Não autorizado") unless Upload.granted_models_for(user.role).include? model.to_sym
  end

  def self.granted_models_for(role)
    if role == :agent
      [:quote]
    else
      self.model.values
    end
  end

  def pt_model
    I18n.t("activerecord.models.#{model}.other") if model
  end

  def parse
    unless file.respond_to? :read
      errors.add(:file, "Não é possível ler o arquivo") and return
    end
    UploadParserService.new(u: self).run
  rescue StandardError => e
    errors.add(:file, "Erro: #{e}")
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
