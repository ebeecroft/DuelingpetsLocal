class CreateWatchtypes < ActiveRecord::Migration
  def change
    create_table :watchtypes do |t|
      t.string :name
      t.integer :amount
      t.datetime :created_on

      t.timestamps
    end
  end
end
