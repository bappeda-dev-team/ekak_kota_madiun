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

ActiveRecord::Schema.define(version: 2021_11_25_073143) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "kaks", force: :cascade do |t|
    t.text "dasar_hukum"
    t.text "tujuan"
    t.string "penerima_manfaat"
    t.text "data_terpilah"
    t.text "akses"
    t.text "partisipasi"
    t.text "kontrol"
    t.text "manfaat"
    t.text "penyebab_internal"
    t.text "penyebab_external"
    t.text "permasalahan_umum"
    t.text "permasalahan_gender"
    t.text "resiko"
    t.string "lokasi_pelaksanaan"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "program_kegiatan_id"
    t.bigint "pk_id"
    t.index ["pk_id"], name: "index_kaks_on_pk_id"
  end

  create_table "lembagas", force: :cascade do |t|
    t.string "nama_lembaga"
    t.string "tahun"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "opds", force: :cascade do |t|
    t.string "nama_opd"
    t.string "kode_opd"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "lembaga_id"
  end

  create_table "pagus", force: :cascade do |t|
    t.string "item"
    t.integer "uang"
    t.string "tipe"
    t.string "satuan"
    t.integer "volume"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "kak_id"
    t.index ["kak_id"], name: "index_pagus_on_kak_id"
  end

  create_table "pks", force: :cascade do |t|
    t.string "sasaran"
    t.string "indikator_kinerja"
    t.string "target"
    t.string "satuan"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_pks_on_user_id"
  end

  create_table "program_kegiatans", force: :cascade do |t|
    t.string "nama_program"
    t.string "nama_kegiatan"
    t.string "nama_subkegiatan"
    t.string "indikator_kinerja"
    t.string "target"
    t.string "satuan"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "opd_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "nama"
    t.string "nik"
    t.string "password"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "opd_id"
  end

  add_foreign_key "pks", "users"
end
