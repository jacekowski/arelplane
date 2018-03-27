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

ActiveRecord::Schema.define(version: 20180327215726) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cache_data", force: :cascade do |t|
    t.json "map_data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
  end

  create_table "flight_waypoints", force: :cascade do |t|
    t.integer "location_id"
    t.integer "flight_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "flights", force: :cascade do |t|
    t.string "flight_date"
    t.string "aircraft_id"
    t.integer "from_id"
    t.integer "to_id"
    t.string "time_out"
    t.string "time_in"
    t.float "total_time"
    t.float "pic"
    t.float "distance"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
  end

  create_table "locations", force: :cascade do |t|
    t.string "identifier"
    t.string "location_type"
    t.string "name"
    t.string "latitude"
    t.string "longitude"
    t.integer "elevation"
    t.string "continent"
    t.string "iso_country"
    t.string "iso_region"
    t.string "municipality"
    t.string "scheduled_service"
    t.string "gps_code"
    t.string "iata_code"
    t.string "local_code"
    t.string "home_link"
    t.string "wikipedia_link"
    t.string "keywords"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "frequency_khz"
    t.integer "dme_frequency_khz"
    t.string "dme_channel"
    t.float "dme_latitude_deg"
    t.float "dme_longitude_deg"
    t.integer "dme_elevation_ft"
    t.float "slaved_variation_deg"
    t.float "magnetic_variation_deg"
    t.string "usage_type"
    t.string "power"
    t.string "associated_airport"
  end

  create_table "subscription_preferences", force: :cascade do |t|
    t.bigint "user_id"
    t.boolean "new_follower"
    t.boolean "no_emails"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_subscription_preferences_on_user_id"
  end

  create_table "user_followings", force: :cascade do |t|
    t.integer "follower_id"
    t.integer "following_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "logbook_file"
    t.string "username"
    t.string "instagram"
    t.integer "num_airports_cache"
    t.float "total_flight_hours_cache"
    t.integer "num_regions_cache"
    t.integer "flights_count", default: 0
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["flights_count"], name: "index_users_on_flights_count"
    t.index ["name"], name: "index_users_on_name"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username"
  end

end
