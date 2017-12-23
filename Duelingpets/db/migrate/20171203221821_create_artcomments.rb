class CreateArtcomments < ActiveRecord::Migration
  def change
    create_table :artcomments do |t|
      t.text :message
      t.boolean :critique, default: false
      t.datetime :created_on
      t.integer :art_id
      t.integer :user_id

      t.timestamps
    end
  end
end
