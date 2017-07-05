class ChangeDataTypeForSourceAdjustment < ActiveRecord::Migration[5.1]
  def change
  	remove_column :costs ,:source_adjustment, :decimal
  	add_column :costs, :source_adjustment, :string
  end
end
