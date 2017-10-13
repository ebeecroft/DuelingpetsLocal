class CreateMoviecomments < ActiveRecord::Migration
  def change
    create_table :moviecomments do |t|
      t.text :message
      t.datetime :created_on
      t.integer :movie_id
      t.integer :user_id

      t.timestamps
    end
  end
end
