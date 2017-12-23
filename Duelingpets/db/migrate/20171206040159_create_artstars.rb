class CreateArtstars < ActiveRecord::Migration
  def change
    create_table :artstars do |t|
      t.datetime :created_on
      t.integer :user_id
      t.integer :art_id

      t.timestamps
    end
  end
end
