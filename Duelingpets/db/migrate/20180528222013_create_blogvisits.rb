class CreateBlogvisits < ActiveRecord::Migration
  def change
    create_table :blogvisits do |t|
      t.datetime :created_on
      t.integer :user_id
      t.integer :blog_id

      t.timestamps
    end
  end
end
