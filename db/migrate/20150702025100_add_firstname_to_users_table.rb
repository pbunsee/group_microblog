class AddFirstnameToUsersTable < ActiveRecord::Migration
  def change
    add_column :users, :firstname, :string
  end
end
