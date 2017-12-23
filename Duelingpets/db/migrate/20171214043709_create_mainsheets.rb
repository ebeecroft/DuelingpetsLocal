class CreateMainsheets < ActiveRecord::Migration
  def change
    create_table :mainsheets do |t|
      t.string :title
      t.text :description
      t.datetime :created_on
      t.integer :user_id
      t.integer :radiostation_id

      t.timestamps
    end
  end
end
