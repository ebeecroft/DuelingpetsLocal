class CreatePmreplies < ActiveRecord::Migration
  def change
    create_table :pmreplies do |t|
      t.text :message
      t.datetime :created_on
      t.integer :pm_id
      t.integer :user_id
      t.string :mp4
      t.string :ogv

      t.timestamps
    end
  end
end
