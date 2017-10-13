class CreateReplies < ActiveRecord::Migration
  def change
    create_table :replies do |t|
      t.text :message
      t.datetime :created_on
      t.integer :blog_id
      t.integer :user_id

      t.timestamps
    end
  end
end
