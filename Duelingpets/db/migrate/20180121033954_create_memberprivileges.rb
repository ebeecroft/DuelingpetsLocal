class CreateMemberprivileges < ActiveRecord::Migration
  def change
    create_table :memberprivileges do |t|
      t.string :name
      t.datetime :created_on

      t.timestamps
    end
  end
end
