class CreateDonors < ActiveRecord::Migration
  def change
    create_table :donors do |t|
      t.text :description
      t.datetime :created_on
      t.integer :user_id
      t.integer :donationbox_id
      t.integer :amount

      t.timestamps
    end
  end
end
