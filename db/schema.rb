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

ActiveRecord::Schema.define(version: 20141019210340) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "users", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "salutation"
    t.string   "email"
    t.string   "access_code"
    t.string   "phone"
    t.string   "street_address"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "other_people",            default: [], array: true
    t.integer  "invited_to_ceremony"
    t.integer  "invited_to_reception"
    t.string   "invited_by"
    t.integer  "invitee_batch_a"
    t.integer  "invitee_batch_b"
    t.integer  "rsvp_ceremony"
    t.integer  "rsvp_reception"
    t.integer  "rsvp_sent"
    t.integer  "reminder_sent"
    t.integer  "wedding_info_sent"
    t.string   "table_number"
    t.integer  "permission"
    t.string   "pass_md5"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "full_name"
    t.integer  "invited_to_ca_reception"
    t.integer  "rsvp_ca_reception"
    t.string   "note"
  end

end
