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

ActiveRecord::Schema[7.1].define(version: 2024_05_05_233559) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "email_notifications", force: :cascade do |t|
    t.string "title"
    t.string "body"
    t.bigint "patient_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["patient_id"], name: "index_email_notifications_on_patient_id"
  end

  create_table "medicine_schedules", force: :cascade do |t|
    t.string "disease"
    t.date "start_date"
    t.date "end_date"
    t.integer "status", default: 0
    t.bigint "patient_id", null: false
    t.index ["patient_id"], name: "index_medicine_schedules_on_patient_id"
  end

  create_table "medicines", force: :cascade do |t|
    t.string "name"
    t.integer "frequency"
    t.integer "number_of_frequency", default: 0
    t.integer "number_of_pill", default: 0
    t.jsonb "set_of_time", default: {}
    t.json "schedule", default: {}
    t.integer "status", default: 0
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "medicine_schedule_id", null: false
    t.index ["medicine_schedule_id"], name: "index_medicines_on_medicine_schedule_id"
  end

  create_table "patients", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "time_zone"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_patients_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "email_notifications", "patients"
  add_foreign_key "medicine_schedules", "patients"
  add_foreign_key "medicines", "medicine_schedules"
  add_foreign_key "patients", "users"
end
