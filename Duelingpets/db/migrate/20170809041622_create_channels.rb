class CreateChannels < ActiveRecord::Migration
  def change
    create_table :channels do |t|
      t.string :name
      t.text :description
      t.datetime :created_on
      t.integer :user_id

      t.timestamps
    end
  end
end
