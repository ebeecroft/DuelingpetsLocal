class CreateArtvisits < ActiveRecord::Migration
  def change
    create_table :artvisits do |t|
      t.datetime :created_on
      t.integer :user_id
      t.integer :art_id

      t.timestamps
    end
  end
end
