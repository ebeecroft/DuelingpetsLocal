class CreateMaintopicmoderators < ActiveRecord::Migration
  def change
    create_table :maintopicmoderators do |t|
      t.datetime :created_on
      t.integer :user_id
      t.integer :maintopic_id

      t.timestamps
    end
  end
end
