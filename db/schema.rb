# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_10_10_013001) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "hstore"
  enable_extension "plpgsql"

  create_table "comments", force: :cascade do |t|
    t.text "message"
    t.datetime "commented_at"
    t.bigint "user_id"
    t.bigint "post_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "event_timeline_id"
    t.index ["event_timeline_id"], name: "index_comments_on_event_timeline_id"
    t.index ["post_id"], name: "index_comments_on_post_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "event_timelines", force: :cascade do |t|
    t.bigint "user_id"
    t.datetime "created_at"
    t.boolean "passed_four_stars"
    t.index ["user_id"], name: "index_event_timelines_on_user_id"
  end

  create_table "github_events", force: :cascade do |t|
    t.string "type"
    t.string "repository"
    t.string "branch"
    t.integer "pull_request_number"
    t.datetime "timestamp"
    t.bigint "event_timeline_id"
    t.index ["event_timeline_id"], name: "index_github_events_on_event_timeline_id"
  end

  create_table "jwt_denylist", force: :cascade do |t|
    t.string "jti", null: false
    t.datetime "exp", null: false
    t.index ["jti"], name: "index_jwt_denylist_on_jti"
  end

  create_table "posts", force: :cascade do |t|
    t.string "title"
    t.text "body"
    t.datetime "posted_at"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "comments_count"
    t.bigint "event_timeline_id"
    t.index ["event_timeline_id"], name: "index_posts_on_event_timeline_id"
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "ratings", force: :cascade do |t|
    t.integer "rating"
    t.datetime "rated_at"
    t.bigint "user_id"
    t.bigint "rater_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "event_timeline_id"
    t.index ["event_timeline_id"], name: "index_ratings_on_event_timeline_id"
    t.index ["rated_at"], name: "index_ratings_on_rated_at"
    t.index ["rater_id"], name: "index_ratings_on_rater_id"
    t.index ["user_id"], name: "index_ratings_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "github_username"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.decimal "average_rating", default: "1.0", null: false
    t.datetime "passed_four_stars"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "registered_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "comments_count"
    t.integer "posts_count"
    t.integer "ratings_count"
    t.index ["average_rating"], name: "index_users_on_average_rating"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["github_username"], name: "index_users_on_github_username"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "comments", "event_timelines"
  add_foreign_key "posts", "event_timelines"
  add_foreign_key "ratings", "event_timelines"
  add_foreign_key "ratings", "users"
  add_foreign_key "ratings", "users", column: "rater_id"
end
