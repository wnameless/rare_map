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

ActiveRecord::Schema.define(version: 0) do

  create_table "access_log", force: true do |t|
    t.string   "url",        limit: 100, null: false
    t.string   "user_agent", limit: 100
    t.string   "ip",         limit: 64
    t.integer  "user_id"
    t.datetime "date",                   null: false
  end

  create_table "admin_audit_log", force: true do |t|
    t.integer  "admin_id",         null: false
    t.string   "event",            null: false
    t.string   "object_reference"
    t.integer  "object_id"
    t.datetime "event_timestamp",  null: false
  end

  create_table "admin_previous_passwords", primary_key: "previous_passwords_id", force: true do |t|
    t.integer  "user_id",           null: false
    t.string   "previous_password", null: false
    t.datetime "date",              null: false
  end

  create_table "app_user", force: true do |t|
    t.boolean  "account_expired",                               null: false
    t.boolean  "account_locked",                                null: false
    t.string   "address",               limit: 150
    t.string   "city",                  limit: 50
    t.string   "country",               limit: 100
    t.string   "postal_code",           limit: 15
    t.string   "province",              limit: 100
    t.boolean  "credentials_expired",                           null: false
    t.string   "email",                                         null: false
    t.boolean  "account_enabled"
    t.string   "first_name",            limit: 50,              null: false
    t.string   "last_name",             limit: 50,              null: false
    t.string   "password",                                      null: false
    t.string   "password_hint"
    t.string   "phone_number"
    t.string   "username",              limit: 50,              null: false
    t.integer  "version"
    t.string   "website"
    t.datetime "last_pass_update_date",                         null: false
    t.integer  "num_incorrect_pw",                  default: 0, null: false
    t.datetime "lockout_start"
    t.string   "nih_username",          limit: 50
  end

  add_index "app_user", ["email"], name: "app_user_email_uq", unique: true, using: :btree
  add_index "app_user", ["username"], name: "app_user_username_uq", unique: true, using: :btree

  create_table "audit_log_guid", force: true do |t|
    t.integer  "user_id"
    t.string   "event"
    t.datetime "event_date"
    t.string   "success",    limit: 1
  end

  create_table "guidmeta", id: false, force: true do |t|
    t.string   "database_version",           limit: 10
    t.string   "application_version",        limit: 10
    t.datetime "database_version_update_dt"
  end

  create_table "invalid_guid_map", primary_key: "invalid_guid_map_id", force: true do |t|
    t.string   "invalid_guid",        limit: 25, null: false
    t.integer  "creator_id",                     null: false
    t.datetime "date_created",                   null: false
    t.integer  "updater_id"
    t.datetime "date_updated"
    t.integer  "referred_subject_id"
  end

  add_index "invalid_guid_map", ["invalid_guid"], name: "invalid_guid_uq", unique: true, using: :btree

  create_table "organization", primary_key: "org_id", force: true do |t|
    t.string   "name",                                            null: false
    t.string   "full_name",           limit: 500
    t.string   "description"
    t.string   "end_point_reference"
    t.datetime "date_created",                                    null: false
    t.integer  "creator_id"
    t.datetime "date_updated"
    t.integer  "updater_id"
    t.boolean  "deleted",                         default: false, null: false
  end

  add_index "organization", ["name"], name: "organization_uq", unique: true, using: :btree

  create_table "previous_passwords", primary_key: "previous_passwords_id", force: true do |t|
    t.integer  "user_map_id",       null: false
    t.string   "previous_password", null: false
    t.datetime "date",              null: false
  end

  create_table "role", id: false, force: true do |t|
    t.integer "id",                     null: false
    t.string  "description", limit: 64
    t.string  "name",        limit: 20
  end

  create_table "site", primary_key: "site_id", force: true do |t|
    t.string   "user_name",     limit: 64,                  null: false
    t.string   "site_password",                             null: false
    t.string   "email_address", limit: 128
    t.string   "phone_number",  limit: 64
    t.integer  "creator_id"
    t.datetime "date_created",                              null: false
    t.integer  "updater_id"
    t.datetime "date_updated"
    t.integer  "org_id",                                    null: false
    t.boolean  "deleted",                   default: false, null: false
  end

  add_index "site", ["user_name"], name: "user_account_user_name_key", unique: true, using: :btree

  create_table "siteuser", primary_key: "user_map_id", force: true do |t|
    t.integer  "site_id",                                           null: false
    t.string   "user_id",               limit: 25,                  null: false
    t.datetime "date_created",                                      null: false
    t.string   "last_name",             limit: 64
    t.string   "first_name",            limit: 64
    t.string   "email_address",         limit: 128
    t.string   "phone_number",          limit: 64
    t.string   "user_name",             limit: 64
    t.string   "user_password"
    t.integer  "creator_id"
    t.datetime "date_updated"
    t.integer  "updater_id"
    t.boolean  "deleted",                           default: false, null: false
    t.integer  "num_incorrect_pw",                  default: 0,     null: false
    t.datetime "lockout_start"
    t.datetime "last_pass_update_date",                             null: false
    t.string   "nih_username",          limit: 50
  end

  create_table "subject", primary_key: "subject_id", force: true do |t|
    t.string   "guid",            limit: 25,             null: false
    t.integer  "subject_type",                           null: false
    t.binary   "hashcode1"
    t.binary   "hashcode2"
    t.binary   "hashcode3"
    t.integer  "creator_id",                             null: false
    t.datetime "date_created",                           null: false
    t.datetime "date_updated"
    t.integer  "status",                     default: 2, null: false
    t.integer  "updater_id"
    t.integer  "creator_user_id",                        null: false
    t.integer  "updater_user_id"
  end

  create_table "subject_merging_map", primary_key: "subject_merging_map_id", force: true do |t|
    t.integer  "referring_subject_id", null: false
    t.integer  "referred_subject_id",  null: false
    t.integer  "creator_id",           null: false
    t.datetime "date_created",         null: false
    t.integer  "updater_id"
    t.datetime "date_updated"
  end

  create_table "subject_request", primary_key: "subject_request_id", force: true do |t|
    t.integer  "subject_id"
    t.integer  "requestor_id",        null: false
    t.datetime "date_requested",      null: false
    t.integer  "notification_status", null: false
    t.integer  "updater_id"
    t.datetime "date_updated"
    t.integer  "creator_user_id",     null: false
  end

  create_table "user_role", id: false, force: true do |t|
    t.integer "user_id", null: false
    t.integer "role_id", null: false
  end

end
