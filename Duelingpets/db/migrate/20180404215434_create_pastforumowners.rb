class CreatePastforumowners < ActiveRecord::Migration
  def change
    create_table :pastforumowners do |t|
      t.string :status
      t.datetime :created_on
      t.integer :forum_id
      t.integer :user_id
      t.integer :pastowner_id

      t.timestamps
    end
  end
end
