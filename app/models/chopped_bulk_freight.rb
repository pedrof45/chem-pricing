class ChoppedBulkFreight < ApplicationRecord

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
