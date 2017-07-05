class ChangeDataTypeForCompetitionAdjustment < ActiveRecord::Migration[5.1]
  def change
  	remove_column :costs ,:competition_adjustment, :decimal
  	add_column :costs, :competition_adjustment, :string
  end
end
