class CreateGalleryvisits < ActiveRecord::Migration
  def change
    create_table :galleryvisits do |t|
      t.datetime :created_on
      t.integer :user_id
      t.integer :gallery_id

      t.timestamps
    end
  end
end
