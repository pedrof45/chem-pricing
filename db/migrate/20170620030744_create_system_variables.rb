class CreateSystemVariables < ActiveRecord::Migration[5.1]
  def change
    create_table :system_variables do |t|
      t.string :name
      t.decimal :value

      t.timestamps
    end
  end
end
