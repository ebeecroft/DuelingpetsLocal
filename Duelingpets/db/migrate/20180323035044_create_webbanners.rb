class CreateWebbanners < ActiveRecord::Migration
  def change
    create_table :webbanners do |t|
      t.string :name
      t.datetime :created_on
      t.string :banner

      t.timestamps
    end
  end
end
