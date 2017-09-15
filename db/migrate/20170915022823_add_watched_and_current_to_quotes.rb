class AddWatchedAndCurrentToQuotes < ActiveRecord::Migration[5.1]
  def change
    add_column :quotes, :watched, :boolean
    add_column :quotes, :current, :boolean
  end
end
