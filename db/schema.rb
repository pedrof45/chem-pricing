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

ActiveRecord::Schema.define(version: 20170617041126) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "business_units", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cities", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "costs", force: :cascade do |t|
    t.bigint "product_id"
    t.bigint "dist_center_id"
    t.decimal "base_price"
    t.string "currency"
    t.decimal "suggested_markup"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "unit"
    t.decimal "amount_for_price"
    t.boolean "updated_cost"
    t.decimal "last_month_base_price"
    t.decimal "last_month_fob_net"
    t.string "product_analyst"
    t.integer "lead_time"
    t.decimal "min_order_quantity"
    t.string "frac_emb"
    t.decimal "source_adjustment"
    t.decimal "competition_adjustment"
    t.string "commentary"
    t.index ["dist_center_id"], name: "index_costs_on_dist_center_id"
    t.index ["product_id"], name: "index_costs_on_product_id"
  end

  create_table "countries", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "customers", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "country_id"
    t.bigint "city_id"
    t.string "cnpj"
    t.string "contact"
    t.index ["city_id"], name: "index_customers_on_city_id"
    t.index ["country_id"], name: "index_customers_on_country_id"
  end

  create_table "dist_centers", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "city_id"
    t.index ["city_id"], name: "index_dist_centers_on_city_id"
  end

  create_table "icms_taxes", force: :cascade do |t|
    t.string "origin"
    t.string "destination"
    t.decimal "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "optimal_markups", force: :cascade do |t|
    t.bigint "product_id"
    t.bigint "customer_id"
    t.bigint "dist_center_id"
    t.decimal "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "table_value"
    t.bigint "business_unit_id"
    t.index ["business_unit_id"], name: "index_optimal_markups_on_business_unit_id"
    t.index ["customer_id"], name: "index_optimal_markups_on_customer_id"
    t.index ["dist_center_id"], name: "index_optimal_markups_on_dist_center_id"
    t.index ["product_id"], name: "index_optimal_markups_on_product_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "sku"
    t.string "name"
    t.string "unit"
    t.string "currency"
    t.decimal "ipi"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "density"
    t.boolean "resolution13"
    t.integer "origin"
    t.boolean "commodity"
    t.string "ncm"
  end

  create_table "quotes", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "customer_id"
    t.bigint "product_id"
    t.datetime "quote_date"
    t.string "payment_term"
    t.boolean "icms_padrao"
    t.decimal "icms"
    t.decimal "ipi"
    t.boolean "pis_confins_padrao"
    t.decimal "pis_confins"
    t.string "freight_condition"
    t.decimal "brl_usd"
    t.decimal "brl_eur"
    t.decimal "quantity"
    t.string "unit"
    t.decimal "unit_price"
    t.decimal "markup"
    t.boolean "fixed_price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "dist_center_id"
    t.bigint "city_id"
    t.index ["city_id"], name: "index_quotes_on_city_id"
    t.index ["customer_id"], name: "index_quotes_on_customer_id"
    t.index ["dist_center_id"], name: "index_quotes_on_dist_center_id"
    t.index ["product_id"], name: "index_quotes_on_product_id"
    t.index ["user_id"], name: "index_quotes_on_user_id"
  end

  create_table "sales", force: :cascade do |t|
    t.datetime "sale_date"
    t.bigint "customer_id"
    t.bigint "product_id"
    t.bigint "dist_center_id"
    t.bigint "user_id"
    t.bigint "business_unit_id"
    t.string "moneda"
    t.string "unit"
    t.decimal "volume"
    t.decimal "base_price"
    t.decimal "unit_price"
    t.string "calculated"
    t.decimal "markup"
    t.string "comentario"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["business_unit_id"], name: "index_sales_on_business_unit_id"
    t.index ["customer_id"], name: "index_sales_on_customer_id"
    t.index ["dist_center_id"], name: "index_sales_on_dist_center_id"
    t.index ["product_id"], name: "index_sales_on_product_id"
    t.index ["user_id"], name: "index_sales_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "position"
    t.string "role"
    t.boolean "active"
    t.bigint "business_unit_id"
    t.index ["business_unit_id"], name: "index_users_on_business_unit_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "costs", "dist_centers"
  add_foreign_key "costs", "products"
  add_foreign_key "optimal_markups", "customers"
  add_foreign_key "optimal_markups", "dist_centers"
  add_foreign_key "optimal_markups", "products"
  add_foreign_key "quotes", "customers"
  add_foreign_key "quotes", "products"
  add_foreign_key "quotes", "users"
  add_foreign_key "sales", "business_units"
  add_foreign_key "sales", "customers"
  add_foreign_key "sales", "dist_centers"
  add_foreign_key "sales", "products"
end
