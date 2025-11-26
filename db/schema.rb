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

ActiveRecord::Schema[7.2].define(version: 2025_11_26_203000) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "badges", force: :cascade do |t|
    t.bigint "student_id", null: false
    t.bigint "section_id", null: false
    t.integer "level", null: false
    t.date "awarded_at", null: false
    t.bigint "awarded_by_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["awarded_at"], name: "index_badges_on_awarded_at"
    t.index ["awarded_by_id"], name: "index_badges_on_awarded_by_id"
    t.index ["section_id"], name: "index_badges_on_section_id"
    t.index ["student_id", "section_id", "level"], name: "index_badges_on_student_id_and_section_id_and_level", unique: true
    t.index ["student_id"], name: "index_badges_on_student_id"
  end

  create_table "classrooms", force: :cascade do |t|
    t.string "name", null: false
    t.string "year_group"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "name"], name: "index_classrooms_on_user_id_and_name"
    t.index ["user_id"], name: "index_classrooms_on_user_id"
  end

  create_table "experiences_outcomes", force: :cascade do |t|
    t.string "code"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_experiences_outcomes_on_code", unique: true
  end

  create_table "experiences_outcomes_sections", id: false, force: :cascade do |t|
    t.bigint "section_id", null: false
    t.bigint "experiences_outcome_id", null: false
    t.index ["experiences_outcome_id", "section_id"], name: "index_sections_eo_on_eo_and_section"
    t.index ["section_id", "experiences_outcome_id"], name: "index_sections_eo_on_section_and_eo"
  end

  create_table "experiences_outcomes_skills", id: false, force: :cascade do |t|
    t.bigint "skill_id", null: false
    t.bigint "experiences_outcome_id", null: false
    t.index ["experiences_outcome_id", "skill_id"], name: "index_skills_eo_on_eo_and_skill"
    t.index ["skill_id", "experiences_outcome_id"], name: "index_skills_eo_on_skill_and_eo"
  end

  create_table "sections", force: :cascade do |t|
    t.string "name", null: false
    t.string "category", null: false
    t.text "description"
    t.string "icon"
    t.integer "position", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "experiences_and_outcomes"
    t.index ["category"], name: "index_sections_on_category"
    t.index ["position"], name: "index_sections_on_position"
  end

  create_table "skills", force: :cascade do |t|
    t.text "description", null: false
    t.integer "level", default: 0, null: false
    t.bigint "section_id", null: false
    t.integer "position", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "experiences_and_outcomes"
    t.index ["position"], name: "index_skills_on_position"
    t.index ["section_id", "level"], name: "index_skills_on_section_id_and_level"
    t.index ["section_id"], name: "index_skills_on_section_id"
  end

  create_table "student_skills", force: :cascade do |t|
    t.bigint "student_id", null: false
    t.bigint "skill_id", null: false
    t.boolean "demonstrated", default: false
    t.date "demonstrated_at"
    t.text "teacher_notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["demonstrated"], name: "index_student_skills_on_demonstrated"
    t.index ["skill_id"], name: "index_student_skills_on_skill_id"
    t.index ["student_id", "skill_id"], name: "index_student_skills_on_student_id_and_skill_id", unique: true
    t.index ["student_id"], name: "index_student_skills_on_student_id"
  end

  create_table "students", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.bigint "classroom_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["classroom_id", "last_name", "first_name"], name: "index_students_on_classroom_id_and_last_name_and_first_name"
    t.index ["classroom_id"], name: "index_students_on_classroom_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "school"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "badges", "sections"
  add_foreign_key "badges", "students"
  add_foreign_key "badges", "users", column: "awarded_by_id"
  add_foreign_key "classrooms", "users"
  add_foreign_key "skills", "sections"
  add_foreign_key "student_skills", "skills"
  add_foreign_key "student_skills", "students"
  add_foreign_key "students", "classrooms"
end
