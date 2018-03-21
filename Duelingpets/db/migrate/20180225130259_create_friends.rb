class CreateFriends < ActiveRecord::Migration
  def change
    create_table :friends do |t|
      t.datetime :created_on
      t.integer :user_id
      t.integer :from_user_id

      t.timestamps
    end
  end
end
