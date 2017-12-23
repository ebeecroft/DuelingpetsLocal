class CreateRadiostations < ActiveRecord::Migration
  def change
    create_table :radiostations do |t|
      t.string :name
      t.text :description
      t.string :mp4
      t.string :ogv
      t.datetime :created_on
      t.integer :user_id
      t.boolean :video_on, default: false

      t.timestamps
    end
  end
end
