class CreateMovies < ActiveRecord::Migration
  def change
    create_table :movies do |t|
      t.string :title
      t.text :description
      t.datetime :created_on
      t.integer :user_id
      t.integer :subplaylist_id
      t.integer :bookgroup_id
      t.boolean :reviewed, default: false
      t.string :mp4
      t.string :ogv

      t.timestamps
    end
  end
end
