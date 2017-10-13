class CreateShouts < ActiveRecord::Migration
  def change
    create_table :shouts do |t|
      t.text :message
      t.datetime :created_on
      t.integer :user_id
      t.integer :from_user_id

      t.timestamps
    end
  end
end
