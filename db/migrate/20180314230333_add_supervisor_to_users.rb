class AddSupervisorToUsers < ActiveRecord::Migration[5.1]
  def change
    add_reference :users, :supervisor, index: true
  end
end
