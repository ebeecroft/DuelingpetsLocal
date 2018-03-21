class CreatePagesounds < ActiveRecord::Migration
  def change
    create_table :pagesounds do |t|
      t.string :name
      t.datetime :created_on
      t.string :ogg
      t.string :mp3

      t.timestamps
    end
  end
end
