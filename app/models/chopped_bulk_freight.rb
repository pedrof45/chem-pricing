class ChoppedBulkFreight < ApplicationRecord
  belongs_to :upload, required: false

  # removed
  # after_save :update_watched_quotes
  # def update_watched_quotes
  #   WatchedUpdateService.new.run_for_freight_obj(self)
  # end

  def self.translations
    all.map do |cbf|
      ["chopped_#{cbf.id}", cbf.operation]
    end.to_h
  end

  def self.xls_mode
    :update
  end

  def self.xls_fields
    {
      operation: :key,
      amount: :attr
    }
  end

end

# == Schema Information
#
# Table name: chopped_bulk_freights
#
#  id         :integer          not null, primary key
#  operation  :string
#  amount     :decimal(, )
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  upload_id  :integer
#
# Indexes
#
#  index_chopped_bulk_freights_on_upload_id  (upload_id)
#
