class CreateProfileTable < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.string :fname
      t.string :lname
      t.string :email
      t.string :city
      t.date :dob
      t.datetime :membersince
    end
  end
end
