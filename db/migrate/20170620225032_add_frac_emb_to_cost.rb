class AddFracEmbToCost < ActiveRecord::Migration[5.1]
  def change
    add_column :costs, :frac_emb, :boolean
  end
end
