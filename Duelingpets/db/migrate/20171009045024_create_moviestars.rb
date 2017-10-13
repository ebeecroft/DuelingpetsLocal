class CreateMoviestars < ActiveRecord::Migration
  def change
    create_table :moviestars do |t|
      t.datetime :created_on
      t.integer :user_id
      t.integer :movie_id

      t.timestamps
    end
  end
end
