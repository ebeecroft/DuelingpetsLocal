class CreateRegistrations < ActiveRecord::Migration
  def change
    create_table :registrations do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :country
      t.string :country_timezone
      t.date :birthday
      t.string :login_id
      t.string :vname
      t.datetime :joined_on
      t.boolean :admin, default: false

      t.timestamps
    end
  end
end
