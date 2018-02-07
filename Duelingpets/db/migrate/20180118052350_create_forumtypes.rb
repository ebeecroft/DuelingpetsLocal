class CreateForumtypes < ActiveRecord::Migration
  def change
    create_table :forumtypes do |t|
      t.string :name
      t.datetime :created_on

      t.timestamps
    end
  end
end
