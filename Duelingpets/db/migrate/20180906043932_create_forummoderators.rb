class CreateForummoderators < ActiveRecord::Migration
  def change
    create_table :forummoderators do |t|
      t.datetime :created_on
      t.integer :user_id
      t.integer :forum_id

      t.timestamps
    end
  end
end
