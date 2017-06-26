class RenameTypeFromNormalPackedFreight < ActiveRecord::Migration[5.1]
  def change
    rename_column :normal_packed_freights, :type, :category
  end
end
