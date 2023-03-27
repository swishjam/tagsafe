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

ActiveRecord::Schema.define(version: 2023_03_25_234857) do

  create_table "active_storage_attachments", charset: "utf8mb3", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", charset: "utf8mb3", force: :cascade do |t|
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

  create_table "active_storage_variant_records", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "organizations", charset: "utf8mb3", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "unique_key"
  end

  create_table "release_checks", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "tag_id"
    t.timestamp "created_at"
    t.index ["tag_id"], name: "index_release_checks_on_tag_id"
  end

  create_table "tag_identifying_data", charset: "utf8mb3", force: :cascade do |t|
    t.string "name"
    t.string "company"
    t.string "homepage"
    t.string "category"
  end

  create_table "tag_identifying_data_domains", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "tag_identifying_data_id", null: false
    t.string "url_pattern"
    t.index ["tag_identifying_data_id"], name: "index_tag_identifying_data_domains_on_tag_identifying_data_id"
    t.index ["url_pattern"], name: "index_tag_identifying_data_domains_on_url_pattern"
  end

  create_table "tag_versions", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "tag_id"
    t.string "version_key"
    t.string "hashed_content"
    t.string "host_url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "original_content_byte_size"
    t.integer "minified_byte_size"
    t.string "sha_256"
    t.string "original_content_host_url"
    t.string "minified_content_host_url"
    t.index ["tag_id"], name: "index_tag_versions_on_tag_id"
  end

  create_table "tags", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "organization_id"
    t.text "full_url"
    t.string "url_host"
    t.string "url_path"
    t.string "url_query"
    t.string "current_version_host_url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "tag_identifying_data_id"
    t.bigint "currently_live_tag_version_id"
    t.index ["currently_live_tag_version_id"], name: "index_tags_on_currently_live_tag_version_id"
    t.index ["organization_id"], name: "index_tags_on_organization_id"
    t.index ["tag_identifying_data_id"], name: "index_tags_on_tag_identifying_data_id"
  end

  create_table "users", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "organization_id", null: false
    t.string "email"
    t.string "password_digest"
    t.string "first_name"
    t.string "last_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["organization_id"], name: "index_users_on_organization_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "tag_identifying_data_domains", "tag_identifying_data", column: "tag_identifying_data_id"
  add_foreign_key "tags", "tag_identifying_data", column: "tag_identifying_data_id"
  add_foreign_key "users", "organizations"
end
