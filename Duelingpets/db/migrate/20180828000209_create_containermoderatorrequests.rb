class CreateContainermoderatorrequests < ActiveRecord::Migration
  def change
    create_table :containermoderatorrequests do |t|
      t.text :message
      t.datetime :created_on
      t.string :status
      t.integer :user_id
      t.integer :topiccontainer_id

      t.timestamps
    end
  end
end
