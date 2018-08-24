class CreateSubtopicsubscribers < ActiveRecord::Migration
  def change
    create_table :subtopicsubscribers do |t|
      t.datetime :created_on
      t.integer :user_id
      t.integer :subtopic_id

      t.timestamps
    end
  end
end
