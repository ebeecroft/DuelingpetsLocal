class CreateForuminvites < ActiveRecord::Migration
  def change
    create_table :foruminvites do |t|
      t.text :message
      t.datetime :created_on
      t.string :status
      t.integer :user_id
      t.integer :from_user_id
      t.integer :forum_id

      t.timestamps
    end
  end
end
