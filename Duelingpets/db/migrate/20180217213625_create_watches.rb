class CreateWatches < ActiveRecord::Migration
  def change
    create_table :watches do |t|
      t.integer :watchtype_id
      t.datetime :created_on
      t.integer :user_id
      t.integer :from_user_id

      t.timestamps
    end
  end
end
