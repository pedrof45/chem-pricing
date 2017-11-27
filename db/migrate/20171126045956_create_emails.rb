class CreateEmails < ActiveRecord::Migration[5.1]
  def change
    create_table :emails do |t|
      t.references :user, foreign_key: true
      t.references :customer, foreign_key: true
      t.string :recipient
      t.string :subject
      t.string :message

      t.timestamps
    end
  end
end
