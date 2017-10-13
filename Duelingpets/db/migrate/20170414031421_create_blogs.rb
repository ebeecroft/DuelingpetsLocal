class CreateBlogs < ActiveRecord::Migration
  def change
    create_table :blogs do |t|
      t.string :title
      t.text :description
      t.string :adbanner
      t.string :admascot
      t.string :largeimage1
      t.string :largeimage2
      t.string :largeimage3
      t.string :smallimage1
      t.string :smallimage2
      t.string :smallimage3
      t.string :smallimage4
      t.string :smallimage5
      t.datetime :created_on
      t.integer :user_id
      t.boolean :reviewed, default: false

      t.timestamps
    end
  end
end
