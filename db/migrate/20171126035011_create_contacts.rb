class CreateContacts < ActiveRecord::Migration[5.1]
  def change
    create_table :contacts do |t|
      t.references :customer, foreign_key: true
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :position

      t.timestamps
    end
  end
end
