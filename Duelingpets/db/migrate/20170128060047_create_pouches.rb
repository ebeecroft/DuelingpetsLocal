class CreatePouches < ActiveRecord::Migration
  def change
    create_table :pouches do |t|
      t.integer :user_id
      t.string :privilege, default: "User"
      t.string :remember_token
      t.datetime :expiretime
      t.boolean :activated, default: false
      t.datetime :signed_in_at
      t.datetime :last_visited
      t.datetime :signed_out_at
      t.integer :amount

      t.timestamps
    end
  end
end
