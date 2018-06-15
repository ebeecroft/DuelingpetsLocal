class CreatePagetimers < ActiveRecord::Migration
  def change
    create_table :pagetimers do |t|
      t.string :name
      t.datetime :expiretime
      t.integer :duration
      t.string :timeformat

      t.timestamps
    end
  end
end
