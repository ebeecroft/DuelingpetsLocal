class CreateContainermoderators < ActiveRecord::Migration
  def change
    create_table :containermoderators do |t|
      t.datetime :created_on
      t.integer :user_id
      t.integer :topiccontainer_id

      t.timestamps
    end
  end
end
