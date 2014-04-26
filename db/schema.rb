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

ActiveRecord::Schema.define(version: 20140424111717) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "grades", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "comments",    default: "No Comments"
    t.integer  "question_id"
    t.integer  "student_id"
    t.integer  "grade"
  end

  create_table "questions", force: true do |t|
    t.text     "content"
    t.integer  "number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "points",     default: 0, null: false
    t.integer  "lesson"
    t.string   "difficulty"
  end

  create_table "quiz_locks", force: true do |t|
    t.integer  "student_id"
    t.integer  "quiz_id"
    t.boolean  "locked",     default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "quiz_locks", ["student_id", "quiz_id"], name: "index_quiz_locks_on_student_id_and_quiz_id", unique: true, using: :btree

  create_table "quiz_requests", force: true do |t|
    t.integer  "student_id"
    t.integer  "lesson"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "approved",   default: false
    t.boolean  "retake",     default: false
  end

  add_index "quiz_requests", ["student_id"], name: "index_quiz_requests_on_student_id", using: :btree

  create_table "quizzes", force: true do |t|
    t.integer  "lesson"
    t.integer  "version"
    t.boolean  "retake",     default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_draft",   default: true
  end

  add_index "quizzes", ["lesson", "version", "retake"], name: "index_quizzes_on_lesson_and_version_and_retake", unique: true, using: :btree

  create_table "relationships", force: true do |t|
    t.integer  "quiz_id"
    t.integer  "question_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "relationships", ["question_id", "quiz_id"], name: "index_relationships_on_question_id_and_quiz_id", unique: true, using: :btree
  add_index "relationships", ["question_id"], name: "index_relationships_on_question_id", using: :btree
  add_index "relationships", ["quiz_id"], name: "index_relationships_on_quiz_id", using: :btree

  create_table "solutions", force: true do |t|
    t.text     "content"
    t.integer  "question_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "solutions", ["question_id"], name: "index_solutions_on_question_id", unique: true, using: :btree

  create_table "submissions", force: true do |t|
    t.text     "content"
    t.integer  "question_id"
    t.integer  "student_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "quiz_id"
  end

  add_index "submissions", ["question_id", "student_id"], name: "index_submissions_on_question_id_and_student_id", unique: true, using: :btree
  add_index "submissions", ["quiz_id"], name: "index_submissions_on_quiz_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type"
    t.text     "first_name"
    t.text     "last_name"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
