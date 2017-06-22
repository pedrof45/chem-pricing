class RenameSpecialPackedFreightToNormalPackedFreight < ActiveRecord::Migration[5.1]
  def change
  	rename_table :special_packed_freights, :normal_packed_freights
  end
end
