class CreateJoinTableEmailQuote < ActiveRecord::Migration[5.1]
  def change
    create_join_table :emails, :quotes do |t|
      t.index [:email_id, :quote_id]
      t.index [:quote_id, :email_id]
    end
  end
end
