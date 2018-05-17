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

ActiveRecord::Schema.define(version: 2018_05_17_181445) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "aircrafts", force: :cascade do |t|
    t.string "identifier"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cache_data", force: :cascade do |t|
    t.json "map_data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
  end

  create_table "comments", force: :cascade do |t|
    t.string "commentable_type"
    t.bigint "commentable_id"
    t.bigint "user_id"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["commentable_type", "commentable_id"], name: "index_comments_on_commentable_type_and_commentable_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "flight_waypoints", force: :cascade do |t|
    t.integer "location_id"
    t.integer "flight_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "flights", force: :cascade do |t|
    t.string "flight_date"
    t.string "aircraft_identifier"
    t.bigint "origin_id"
    t.bigint "destination_id"
    t.string "time_out"
    t.string "time_in"
    t.decimal "total_time", precision: 10, scale: 2
    t.float "pic"
    t.float "distance"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.bigint "aircraft_id"
    t.bigint "story_id"
    t.index ["aircraft_id"], name: "index_flights_on_aircraft_id"
    t.index ["destination_id"], name: "index_flights_on_destination_id"
    t.index ["origin_id"], name: "index_flights_on_origin_id"
    t.index ["story_id"], name: "index_flights_on_story_id"
  end

  create_table "likes", force: :cascade do |t|
    t.string "likeable_type"
    t.bigint "likeable_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["likeable_type", "likeable_id"], name: "index_likes_on_likeable_type_and_likeable_id"
    t.index ["user_id"], name: "index_likes_on_user_id"
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

  create_table "notifications", force: :cascade do |t|
    t.integer "recipient_id"
    t.integer "actor_id"
    t.datetime "read_at"
    t.string "action"
    t.integer "notifiable_id"
    t.string "notifiable_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ratings", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stories", force: :cascade do |t|
    t.bigint "user_id"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "map_image_url"
    t.index ["user_id"], name: "index_stories_on_user_id"
  end

  create_table "subscription_preferences", force: :cascade do |t|
    t.bigint "user_id"
    t.boolean "new_follower_email", default: true
    t.boolean "no_emails", default: false
    t.string "unsubscribe_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "story_emails", default: true
    t.index ["user_id"], name: "index_subscription_preferences_on_user_id"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.string "subscribable_type"
    t.bigint "subscribable_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["subscribable_type", "subscribable_id"], name: "index_subscriptions_on_subscribable_type_and_subscribable_id"
    t.index ["user_id"], name: "index_subscriptions_on_user_id"
  end

  create_table "user_followings", force: :cascade do |t|
    t.integer "follower_id"
    t.integer "following_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_ratings", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "rating_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "story_id"
    t.index ["rating_id"], name: "index_user_ratings_on_rating_id"
    t.index ["story_id"], name: "index_user_ratings_on_story_id"
    t.index ["user_id"], name: "index_user_ratings_on_user_id"
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
    t.bigint "home_base_id"
    t.text "bio"
    t.string "employer"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["flights_count"], name: "index_users_on_flights_count"
    t.index ["home_base_id"], name: "index_users_on_home_base_id"
    t.index ["name"], name: "index_users_on_name"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username"
  end

  add_foreign_key "comments", "users"
  add_foreign_key "flights", "aircrafts"
  add_foreign_key "flights", "stories"
  add_foreign_key "likes", "users"
  add_foreign_key "stories", "users"
  add_foreign_key "subscriptions", "users"
  add_foreign_key "user_ratings", "ratings"
  add_foreign_key "user_ratings", "users"
end
