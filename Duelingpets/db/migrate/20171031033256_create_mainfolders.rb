class CreateMainfolders < ActiveRecord::Migration
  def change
    create_table :mainfolders do |t|
      t.string :title
      t.text :description
      t.datetime :created_on
      t.integer :user_id
      t.integer :gallery_id

      t.timestamps
    end
  end
end
