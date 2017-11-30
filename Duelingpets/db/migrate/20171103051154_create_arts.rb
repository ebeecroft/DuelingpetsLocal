class CreateArts < ActiveRecord::Migration
  def change
    create_table :arts do |t|
      t.string :title
      t.text :description
      t.datetime :created_on
      t.integer :user_id
      t.integer :subfolder_id
      t.integer :bookgroup_id
      t.boolean :reviewed, default: false
      t.string :image
      t.string :mp3
      t.string :ogg

      t.timestamps
    end
  end
end
