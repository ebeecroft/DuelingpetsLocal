class CreateBlogstars < ActiveRecord::Migration
  def change
    create_table :blogstars do |t|
      t.datetime :created_on
      t.integer :user_id
      t.integer :blog_id

      t.timestamps
    end
  end
end
