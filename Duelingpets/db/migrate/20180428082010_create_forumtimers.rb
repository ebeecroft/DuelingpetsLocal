class CreateForumtimers < ActiveRecord::Migration
  def change
    create_table :forumtimers do |t|
      t.datetime :forumowner_last_visited
      t.datetime :moderator_last_visited
      t.datetime :member_last_visited
      t.datetime :guest_last_visited
      t.integer :forum_id

      t.timestamps
    end
  end
end
