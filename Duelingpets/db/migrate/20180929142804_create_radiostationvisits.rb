class CreateRadiostationvisits < ActiveRecord::Migration
  def change
    create_table :radiostationvisits do |t|
      t.datetime :created_on
      t.integer :user_id
      t.integer :radiostation_id

      t.timestamps
    end
  end
end
