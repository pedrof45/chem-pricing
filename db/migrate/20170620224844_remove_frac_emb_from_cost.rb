class RemoveFracEmbFromCost < ActiveRecord::Migration[5.1]
  def change
    remove_column :costs, :frac_emb, :string
  end
end
