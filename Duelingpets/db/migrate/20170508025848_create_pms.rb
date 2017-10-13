class CreatePms < ActiveRecord::Migration
  def change
    create_table :pms do |t|
      t.string :title
      t.text :message
      t.datetime :created_on
      t.integer :user_id
      t.integer :from_user_id

      t.timestamps
    end
  end
end
