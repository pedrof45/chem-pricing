class ChangeCostsCommentariesType < ActiveRecord::Migration[5.1]
  def change
    change_column :costs, :commentary, :string
  end
end
