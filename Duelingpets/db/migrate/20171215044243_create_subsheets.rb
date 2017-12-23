class CreateSubsheets < ActiveRecord::Migration
  def change
    create_table :subsheets do |t|
      t.string :title
      t.text :description
      t.datetime :created_on
      t.boolean :collab_mode, default: false
      t.boolean :fave_folder, default: false
      t.integer :user_id
      t.integer :mainsheet_id
      t.integer :bookgroup_id

      t.timestamps
    end
  end
end
