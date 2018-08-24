class CreateArtpages < ActiveRecord::Migration
  def change
    create_table :artpages do |t|
      t.string :name
      t.datetime :created_on
      t.text :message
      t.string :art

      t.timestamps
    end
  end
end
