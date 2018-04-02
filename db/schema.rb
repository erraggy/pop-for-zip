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

ActiveRecord::Schema.define(version: 20180402005941) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cbsa_to_msas", id: false, force: :cascade do |t|
    t.integer "cbsa", null: false
    t.integer "mdiv"
    t.string "name", limit: 80, null: false
    t.string "lsad", limit: 40, null: false
    t.integer "popestimate2014", null: false
    t.integer "popestimate2015", null: false
    t.index ["cbsa"], name: "index_cbsa_to_msas_on_cbsa"
    t.index ["lsad"], name: "index_cbsa_to_msas_on_lsad"
    t.index ["mdiv"], name: "index_cbsa_to_msas_on_mdiv"
  end

  create_table "reload_tasks", force: :cascade do |t|
    t.string "name", limit: 15, null: false
    t.string "status", limit: 10, default: "UPDATING", null: false
    t.integer "total_records", default: 0, null: false
    t.integer "records_processed", default: 0, null: false
    t.index ["name"], name: "index_reload_tasks_on_name", unique: true
    t.index ["status"], name: "index_reload_tasks_on_status"
  end

  create_table "zip_to_cbsas", id: false, force: :cascade do |t|
    t.string "zip", limit: 10, null: false
    t.integer "cbsa", null: false
    t.decimal "res_ratio", precision: 10, scale: 9, null: false
    t.decimal "bus_ratio", precision: 10, scale: 9, null: false
    t.decimal "oth_ratio", precision: 10, scale: 9, null: false
    t.decimal "tot_ratio", precision: 10, scale: 9, null: false
    t.index ["zip"], name: "index_zip_to_cbsas_on_zip"
  end

end
