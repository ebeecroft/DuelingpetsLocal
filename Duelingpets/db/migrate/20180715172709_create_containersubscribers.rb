class CreateContainersubscribers < ActiveRecord::Migration
  def change
    create_table :containersubscribers do |t|
      t.datetime :created_on
      t.integer :user_id
      t.integer :topiccontainer_id

      t.timestamps
    end
  end
end
