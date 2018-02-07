class CreateMaintopics < ActiveRecord::Migration
  def change
    create_table :maintopics do |t|
      t.string :title
      t.text :description
      t.datetime :created_on
      t.string :topicavatar
      t.integer :user_id
      t.integer :topiccontainer_id

      t.timestamps
    end
  end
end
