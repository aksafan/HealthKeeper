# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_10_06_014625) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "biomarkers", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "health_records", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_health_records_on_user_id"
  end

  create_table "lab_tests", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "biomarker_id", null: false
    t.decimal "value"
    t.string "unit"
    t.bigint "reference_range_id", null: false
    t.string "recordable_type"
    t.integer "recordable_id"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["biomarker_id"], name: "index_lab_tests_on_biomarker_id"
    t.index ["reference_range_id"], name: "index_lab_tests_on_reference_range_id"
    t.index ["user_id"], name: "index_lab_tests_on_user_id"
  end

  create_table "measurements", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "measurement_type"
    t.decimal "value"
    t.string "source"
    t.string "recordable_type"
    t.integer "recordable_id"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_measurements_on_user_id"
  end

  create_table "reference_ranges", force: :cascade do |t|
    t.bigint "biomarker_id", null: false
    t.decimal "min_value"
    t.decimal "max_value"
    t.string "unit"
    t.string "source"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["biomarker_id"], name: "index_reference_ranges_on_biomarker_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "health_records", "users"
  add_foreign_key "lab_tests", "biomarkers"
  add_foreign_key "lab_tests", "reference_ranges"
  add_foreign_key "lab_tests", "users"
  add_foreign_key "measurements", "users"
  add_foreign_key "reference_ranges", "biomarkers"
end
