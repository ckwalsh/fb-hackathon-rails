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

ActiveRecord::Schema.define(:version => 20121229210840) do

  create_table "event_sources", :force => true do |t|
    t.string   "fbid"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "events", :force => true do |t|
    t.string   "fbid"
    t.integer  "event_source_id"
    t.string   "name"
    t.datetime "time_start"
    t.datetime "time_end"
    t.string   "timezone"
    t.boolean  "hidden",          :default => false
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  create_table "hack_members_assocs", :force => true do |t|
    t.integer  "hack_id"
    t.integer  "user_id"
    t.boolean  "confirmed",  :default => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "hacks", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "url"
    t.string   "source_url"
    t.string   "image_url"
    t.integer  "event_id"
    t.float    "sort_rand",      :default => 0.0
    t.boolean  "first",          :default => false
    t.string   "published_fbid"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  create_table "users", :force => true do |t|
    t.string  "fbid"
    t.string  "name"
    t.string  "role"
    t.string  "access_token"
    t.integer "token_expire"
  end

end
