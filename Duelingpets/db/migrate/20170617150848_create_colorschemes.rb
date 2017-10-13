class CreateColorschemes < ActiveRecord::Migration
  def change
    create_table :colorschemes do |t|
      t.string :name
      t.text   :description
      t.boolean :activate, default: false
      t.string :backgroundcolor
      t.string :headercolor
      t.string :textcolor
      t.string :navigationcolor
      t.string :navigationlinkcolor
      t.string :navigationhovercolor
      t.string :navigationhoverbackgcolor
      t.string :onlinestatuscolor
      t.string :profilecolor
      t.string :profilevisitedcolor
      t.string :profilehovercolor
      t.string :profilehoverbackgcolor
      t.string :sessioncolor
      t.string :navlinkcolor
      t.string :navlinkhovercolor
      t.string :navlinkhoverbackgcolor
      t.string :explanationborder
      t.string :explanationbackgcolor
      t.string :explanheadercolor
      t.string :explanheaderbackgcolor
      t.string :errorcolor
      t.string :warningcolor
      t.string :notificationcolor
      t.string :successcolor
      t.datetime :created_on
      t.integer :user_id

      t.timestamps
    end
  end
end
