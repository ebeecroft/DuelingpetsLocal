class CreateSubtopics < ActiveRecord::Migration
  def change
    create_table :subtopics do |t|
      t.string :title
      t.text :description
      t.datetime :created_on
      t.string :topicavatar
      t.integer :user_id
      t.integer :maintopic_id
      t.integer :forumgroup_id

      t.timestamps
    end
  end
end
