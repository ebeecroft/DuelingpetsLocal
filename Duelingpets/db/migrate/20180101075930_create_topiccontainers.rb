class CreateTopiccontainers < ActiveRecord::Migration
  def change
    create_table :topiccontainers do |t|
      t.string :title
      t.text :description
      t.datetime :created_on
      t.integer :user_id
      t.integer :forum_id

      t.timestamps
    end
  end
end
