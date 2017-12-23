# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20171215072328) do

  create_table "artcomments", :force => true do |t|
    t.text     "message"
    t.boolean  "critique",   :default => false
    t.datetime "created_on"
    t.integer  "art_id"
    t.integer  "user_id"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "arts", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_on"
    t.integer  "user_id"
    t.integer  "subfolder_id"
    t.integer  "bookgroup_id"
    t.boolean  "reviewed",     :default => false
    t.string   "image"
    t.string   "mp3"
    t.string   "ogg"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  create_table "artstars", :force => true do |t|
    t.datetime "created_on"
    t.integer  "user_id"
    t.integer  "art_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "blogs", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "adbanner"
    t.string   "admascot"
    t.string   "largeimage1"
    t.string   "largeimage2"
    t.string   "largeimage3"
    t.string   "smallimage1"
    t.string   "smallimage2"
    t.string   "smallimage3"
    t.string   "smallimage4"
    t.string   "smallimage5"
    t.datetime "created_on"
    t.integer  "user_id"
    t.boolean  "reviewed",    :default => false
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  create_table "blogstars", :force => true do |t|
    t.datetime "created_on"
    t.integer  "user_id"
    t.integer  "blog_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "bookgroups", :force => true do |t|
    t.string   "name"
    t.datetime "created_on"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "channels", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_on"
    t.integer  "user_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "colorschemes", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.boolean  "activate",                  :default => false
    t.string   "backgroundcolor"
    t.string   "headercolor"
    t.string   "textcolor"
    t.string   "navigationcolor"
    t.string   "navigationlinkcolor"
    t.string   "navigationhovercolor"
    t.string   "navigationhoverbackgcolor"
    t.string   "onlinestatuscolor"
    t.string   "profilecolor"
    t.string   "profilevisitedcolor"
    t.string   "profilehovercolor"
    t.string   "profilehoverbackgcolor"
    t.string   "sessioncolor"
    t.string   "navlinkcolor"
    t.string   "navlinkhovercolor"
    t.string   "navlinkhoverbackgcolor"
    t.string   "explanationborder"
    t.string   "explanationbackgcolor"
    t.string   "explanheadercolor"
    t.string   "explanheaderbackgcolor"
    t.string   "errorfieldcolor"
    t.string   "errorcolor"
    t.string   "warningcolor"
    t.string   "notificationcolor"
    t.string   "successcolor"
    t.datetime "created_on"
    t.integer  "user_id"
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
  end

  create_table "donationboxes", :force => true do |t|
    t.text     "description"
    t.integer  "progress",       :default => 0
    t.integer  "goal",           :default => 0
    t.boolean  "hit_goal",       :default => false
    t.boolean  "turn_on",        :default => false
    t.integer  "user_id"
    t.datetime "initialized_on"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  create_table "donors", :force => true do |t|
    t.text     "description"
    t.datetime "created_on"
    t.integer  "user_id"
    t.integer  "donationbox_id"
    t.integer  "amount"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "favoritearts", :force => true do |t|
    t.datetime "created_on"
    t.integer  "user_id"
    t.integer  "subfolder_id"
    t.integer  "art_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "favoritemovies", :force => true do |t|
    t.datetime "created_on"
    t.integer  "user_id"
    t.integer  "subplaylist_id"
    t.integer  "movie_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "galleries", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "mp3"
    t.string   "ogg"
    t.datetime "created_on"
    t.integer  "user_id"
    t.boolean  "music_on",    :default => false
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  create_table "mainfolders", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_on"
    t.integer  "user_id"
    t.integer  "gallery_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "mainplaylists", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_on"
    t.integer  "user_id"
    t.integer  "channel_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "mainsheets", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_on"
    t.integer  "user_id"
    t.integer  "radiostation_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "maintenancemodes", :force => true do |t|
    t.string   "name"
    t.datetime "created_on"
    t.boolean  "maintenance_on", :default => false
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  create_table "moviecomments", :force => true do |t|
    t.text     "message"
    t.boolean  "critique",   :default => false
    t.datetime "created_on"
    t.integer  "movie_id"
    t.integer  "user_id"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "movies", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_on"
    t.integer  "user_id"
    t.integer  "subplaylist_id"
    t.integer  "bookgroup_id"
    t.boolean  "reviewed",       :default => false
    t.string   "mp4"
    t.string   "ogv"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  create_table "moviestars", :force => true do |t|
    t.datetime "created_on"
    t.integer  "user_id"
    t.integer  "movie_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "pmreplies", :force => true do |t|
    t.text     "message"
    t.datetime "created_on"
    t.integer  "pm_id"
    t.integer  "user_id"
    t.string   "mp4"
    t.string   "ogv"
    t.string   "image"
    t.string   "mp3"
    t.string   "ogg"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "pms", :force => true do |t|
    t.string   "title"
    t.text     "message"
    t.datetime "created_on"
    t.integer  "user_id"
    t.integer  "from_user_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "pouches", :force => true do |t|
    t.integer  "user_id"
    t.string   "privilege",      :default => "User"
    t.string   "remember_token"
    t.datetime "expiretime"
    t.boolean  "activated",      :default => false
    t.datetime "signed_in_at"
    t.datetime "last_visited"
    t.datetime "signed_out_at"
    t.integer  "amount"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  create_table "radiostations", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "mp4"
    t.string   "ogv"
    t.datetime "created_on"
    t.integer  "user_id"
    t.boolean  "video_on",    :default => false
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  create_table "referrals", :force => true do |t|
    t.integer  "user_id"
    t.integer  "referred_by_id"
    t.datetime "created_on"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "registrations", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "country"
    t.string   "country_timezone"
    t.date     "birthday"
    t.string   "login_id"
    t.string   "vname"
    t.datetime "joined_on"
    t.boolean  "admin",            :default => false
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
  end

  create_table "replies", :force => true do |t|
    t.text     "message"
    t.datetime "created_on"
    t.integer  "blog_id"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "shouts", :force => true do |t|
    t.text     "message"
    t.datetime "created_on"
    t.integer  "user_id"
    t.integer  "from_user_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "sounds", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_on"
    t.integer  "user_id"
    t.integer  "subsheet_id"
    t.integer  "bookgroup_id"
    t.boolean  "reviewed",     :default => false
    t.string   "mp3"
    t.string   "ogg"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  create_table "subfolders", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_on"
    t.boolean  "collab_mode",   :default => false
    t.boolean  "fave_folder",   :default => false
    t.integer  "user_id"
    t.integer  "mainfolder_id"
    t.integer  "bookgroup_id"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  create_table "subplaylists", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_on"
    t.boolean  "collab_mode",     :default => false
    t.boolean  "fave_folder",     :default => false
    t.integer  "user_id"
    t.integer  "mainplaylist_id"
    t.integer  "bookgroup_id"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  create_table "subsheets", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_on"
    t.boolean  "collab_mode",  :default => false
    t.boolean  "fave_folder",  :default => false
    t.integer  "user_id"
    t.integer  "mainsheet_id"
    t.integer  "bookgroup_id"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  create_table "suggestions", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_on"
    t.integer  "user_id"
    t.boolean  "applied",     :default => false
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  create_table "userinfos", :force => true do |t|
    t.string   "avatar"
    t.string   "miniavatar"
    t.text     "info"
    t.string   "browser"
    t.string   "vbrowser"
    t.string   "mp3"
    t.string   "ogg"
    t.integer  "user_id"
    t.boolean  "music_on",       :default => false
    t.integer  "colorscheme_id"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "country"
    t.string   "country_timezone"
    t.boolean  "military_time",    :default => false
    t.date     "birthday"
    t.string   "login_id"
    t.string   "vname"
    t.datetime "joined_on"
    t.string   "password_digest"
    t.boolean  "admin",            :default => false
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
  end

end
