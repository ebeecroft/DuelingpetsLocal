class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :country
      t.string :country_timezone
      t.boolean :military_time, default: false
      t.date :birthday
      t.integer :bookgroup_id
      t.string :login_id
      t.string :vname
      t.datetime :joined_on
      t.string :password_digest
      t.boolean :admin, default: false

      t.timestamps
    end
  end
end
