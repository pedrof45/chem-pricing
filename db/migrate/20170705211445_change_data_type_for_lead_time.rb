class ChangeDataTypeForLeadTime < ActiveRecord::Migration[5.1]
  def change
  	remove_column :costs ,:lead_time, :integer
  	add_column :costs, :lead_time, :string
  end
end
