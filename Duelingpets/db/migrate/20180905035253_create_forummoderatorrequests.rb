class CreateForummoderatorrequests < ActiveRecord::Migration
  def change
    create_table :forummoderatorrequests do |t|
      t.text :message
      t.datetime :created_on
      t.string :status
      t.integer :user_id
      t.integer :forum_id

      t.timestamps
    end
  end
end
