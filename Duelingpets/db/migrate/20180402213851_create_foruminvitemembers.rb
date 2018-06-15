class CreateForuminvitemembers < ActiveRecord::Migration
  def change
    create_table :foruminvitemembers do |t|
      t.datetime :created_on
      t.integer :user_id
      t.integer :forum_id

      t.timestamps
    end
  end
end
