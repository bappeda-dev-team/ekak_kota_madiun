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

ActiveRecord::Schema.define(version: 2022_01_09_013855) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "aksis", force: :cascade do |t|
    t.integer "target"
    t.integer "realisasi"
    t.integer "bulan"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "tahapan_id"
    t.index ["tahapan_id"], name: "index_aksis_on_tahapan_id"
  end

  create_table "anggarans", force: :cascade do |t|
    t.string "kode_rek"
    t.text "uraian"
    t.integer "jumlah"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "tahapan_id"
    t.integer "level", default: 0
    t.bigint "parent_id"
    t.bigint "pajak_id"
    t.index ["pajak_id"], name: "index_anggarans_on_pajak_id"
    t.index ["parent_id"], name: "index_anggarans_on_parent_id"
    t.index ["tahapan_id"], name: "index_anggarans_on_tahapan_id"
  end

  create_table "kaks", force: :cascade do |t|
    t.text "dasar_hukum", default: [], array: true
    t.text "tujuan", default: [], array: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_id", null: false
    t.bigint "program_kegiatan_id"
    t.index ["program_kegiatan_id"], name: "index_kaks_on_program_kegiatan_id"
    t.index ["user_id"], name: "index_kaks_on_user_id"
  end

  create_table "kesenjangans", force: :cascade do |t|
    t.bigint "rincian_id", null: false
    t.string "akses"
    t.string "partisipasi"
    t.string "kontrol"
    t.string "manfaat"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["rincian_id"], name: "index_kesenjangans_on_rincian_id"
  end

  create_table "koefisiens", force: :cascade do |t|
    t.integer "volume"
    t.string "satuan_volume"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "perhitungan_id"
    t.index ["perhitungan_id"], name: "index_koefisiens_on_perhitungan_id"
  end

  create_table "latar_belakangs", force: :cascade do |t|
    t.text "dasar_hukum"
    t.text "gambaran_umum"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
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
    t.bigint "sasaran_id", null: false
    t.integer "total"
    t.index ["sasaran_id"], name: "index_pagus_on_sasaran_id"
  end

  create_table "pajaks", force: :cascade do |t|
    t.string "tahun"
    t.string "tipe"
    t.float "potongan"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "perhitungans", force: :cascade do |t|
    t.integer "volume"
    t.string "satuan"
    t.integer "harga"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "anggaran_id"
    t.integer "total"
    t.string "deskripsi"
    t.index ["anggaran_id"], name: "index_perhitungans_on_anggaran_id"
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

  create_table "rincians", force: :cascade do |t|
    t.bigint "sasaran_id", null: false
    t.string "data_terpilah"
    t.string "penyebab_internal"
    t.string "penyebab_external"
    t.string "permasalahan_umum"
    t.string "permasalahan_gender"
    t.string "resiko"
    t.string "lokasi_pelaksanaan"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["sasaran_id"], name: "index_rincians_on_sasaran_id"
  end

  create_table "sasarans", force: :cascade do |t|
    t.string "sasaran_kinerja"
    t.string "indikator_kinerja"
    t.integer "target"
    t.integer "kualitas"
    t.string "satuan"
    t.string "penerima_manfaat"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_id"
    t.bigint "program_kegiatan_id"
    t.integer "anggaran"
    t.index ["program_kegiatan_id"], name: "index_sasarans_on_program_kegiatan_id"
    t.index ["user_id"], name: "index_sasarans_on_user_id"
  end

  create_table "tahapans", force: :cascade do |t|
    t.bigint "rincian_id", null: false
    t.string "tahapan_kerja"
    t.integer "target"
    t.integer "realisasi"
    t.string "bulan"
    t.integer "jumlah_target"
    t.integer "jumlah_realisasi"
    t.string "keterangan"
    t.integer "waktu"
    t.integer "progress"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["rincian_id"], name: "index_tahapans_on_rincian_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "nama"
    t.string "nik"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "opd_id"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "anggarans", "pajaks"
  add_foreign_key "kesenjangans", "rincians"
  add_foreign_key "pagus", "sasarans"
  add_foreign_key "pks", "users"
  add_foreign_key "rincians", "sasarans"
  add_foreign_key "tahapans", "rincians"
end
