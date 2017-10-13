class CreateDonationboxes < ActiveRecord::Migration
  def change
    create_table :donationboxes do |t|
      t.text :description
      t.integer :progress, default: 0
      t.integer :goal, default: 0
      t.boolean :hit_goal, default: false
      t.boolean :turn_on, default: false
      t.integer :user_id
      t.datetime :initialized_on

      t.timestamps
    end
  end
end
