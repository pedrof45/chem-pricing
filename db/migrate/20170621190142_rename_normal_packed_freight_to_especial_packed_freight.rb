class RenameNormalPackedFreightToEspecialPackedFreight < ActiveRecord::Migration[5.1]
  def change
  	rename_table :normal_packed_freights, :especial_packed_freights
  end
end
