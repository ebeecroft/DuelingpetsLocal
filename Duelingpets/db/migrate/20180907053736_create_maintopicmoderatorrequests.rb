class CreateMaintopicmoderatorrequests < ActiveRecord::Migration
  def change
    create_table :maintopicmoderatorrequests do |t|
      t.text :message
      t.datetime :created_on
      t.string :status
      t.integer :user_id
      t.integer :maintopic_id

      t.timestamps
    end
  end
end
