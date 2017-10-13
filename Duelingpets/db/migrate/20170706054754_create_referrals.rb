class CreateReferrals < ActiveRecord::Migration
  def change
    create_table :referrals do |t|
      t.integer :user_id
      t.integer :referred_by_id
      t.datetime :created_on

      t.timestamps
    end
  end
end
