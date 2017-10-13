class CreateBookgroups < ActiveRecord::Migration
  def change
    create_table :bookgroups do |t|
      t.string :name
      t.datetime :created_on

      t.timestamps
    end
  end
end
