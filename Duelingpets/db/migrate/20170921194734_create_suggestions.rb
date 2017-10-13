class CreateSuggestions < ActiveRecord::Migration
  def change
    create_table :suggestions do |t|
      t.string :title
      t.text :description
      t.datetime :created_on
      t.integer :user_id
      t.boolean :applied, default: false

      t.timestamps
    end
  end
end
