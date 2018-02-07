class CreateNarratives < ActiveRecord::Migration
  def change
    create_table :narratives do |t|
      t.text :story
      t.string :mp3
      t.string :ogg
      t.datetime :created_on
      t.integer :user_id
      t.integer :subtopic_id
      t.integer :forumgroup_id

      t.timestamps
    end
  end
end
