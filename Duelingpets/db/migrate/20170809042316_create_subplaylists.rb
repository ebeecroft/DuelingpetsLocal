class CreateSubplaylists < ActiveRecord::Migration
  def change
    create_table :subplaylists do |t|
      t.string :title
      t.text :description
      t.datetime :created_on
      t.boolean :collab_mode, default: false
      t.integer :user_id
      t.integer :mainplaylist_id
      t.integer :bookgroup_id

      t.timestamps
    end
  end
end
