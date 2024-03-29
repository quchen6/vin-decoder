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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20131006224038) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "vehicles", force: true do |t|
    t.integer  "year"
    t.string   "make"
    t.string   "model"
    t.string   "transmission_type"
    t.string   "engine_type"
    t.string   "vin"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "engine_fuel_type"
    t.integer  "engine_cylinder"
    t.float    "engine_size"
    t.string   "trim"
    t.string   "size"
    t.string   "body_type"
    t.string   "style"
    t.json     "extra_attributes"
    t.integer  "style_ids",         default: [], array: true
    t.integer  "search_zip"
    t.integer  "used_tco"
    t.integer  "new_tco"
  end

end
