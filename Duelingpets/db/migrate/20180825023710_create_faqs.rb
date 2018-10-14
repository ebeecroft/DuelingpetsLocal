class CreateFaqs < ActiveRecord::Migration
  def change
    create_table :faqs do |t|
      t.string :title
      t.text :description
      t.datetime :created_on
      t.string :mp3
      t.string :ogg

      t.timestamps
    end
  end
end
