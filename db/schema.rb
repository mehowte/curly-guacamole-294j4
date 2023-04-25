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

ActiveRecord::Schema[7.0].define(version: 2023_04_25_180238) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "question_embeddings", force: :cascade do |t|
    t.string "question", null: false
    t.jsonb "embedding", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["question"], name: "index_question_embeddings_on_question", unique: true
  end

  create_table "questions", force: :cascade do |t|
    t.string "question", null: false
    t.string "answer", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "audio_src_url"
    t.text "context"
    t.string "project_name", default: "book", null: false
    t.string "openai_model", default: "text-davinci-003", null: false
    t.index ["project_name", "question", "openai_model"], name: "index_questions_on_project_name_and_question_and_openai_model", unique: true
  end

end
