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

ActiveRecord::Schema.define(version: 2019_11_24_020137) do

  create_table "assignments", force: :cascade do |t|
    t.integer "store_id", null: false
    t.integer "employee_id", null: false
    t.date "start_date"
    t.date "end_date"
    t.integer "pay_grade_id", null: false
    t.index ["employee_id"], name: "index_assignments_on_employee_id"
    t.index ["pay_grade_id"], name: "index_assignments_on_pay_grade_id"
    t.index ["store_id"], name: "index_assignments_on_store_id"
  end

  create_table "employees", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "ssn"
    t.date "date_of_birth"
    t.string "phone"
    t.string "role"
    t.boolean "active"
    t.string "username"
    t.string "password_digest"
  end

  create_table "jobs", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.boolean "active"
  end

  create_table "pay_grade_rates", force: :cascade do |t|
    t.integer "pay_grade_id", null: false
    t.float "rate"
    t.date "start_date"
    t.date "end_date"
    t.index ["pay_grade_id"], name: "index_pay_grade_rates_on_pay_grade_id"
  end

  create_table "pay_grades", force: :cascade do |t|
    t.string "level"
    t.boolean "active"
  end

  create_table "shift_jobs", force: :cascade do |t|
    t.integer "shift_id", null: false
    t.integer "job_id", null: false
    t.index ["job_id"], name: "index_shift_jobs_on_job_id"
    t.index ["shift_id"], name: "index_shift_jobs_on_shift_id"
  end

  create_table "shifts", force: :cascade do |t|
    t.integer "assignment_id", null: false
    t.date "date"
    t.time "start_time"
    t.time "end_time"
    t.text "notes"
    t.string "status", default: "pending"
    t.index ["assignment_id"], name: "index_shifts_on_assignment_id"
  end

  create_table "stores", force: :cascade do |t|
    t.string "name"
    t.string "street"
    t.string "city"
    t.string "state"
    t.string "zip"
    t.string "phone"
    t.boolean "active"
  end

end
