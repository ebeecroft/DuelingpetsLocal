class CreateForumgroups < ActiveRecord::Migration
  def change
    create_table :forumgroups do |t|
      t.string :name
      t.datetime :created_on

      t.timestamps
    end
  end
end
