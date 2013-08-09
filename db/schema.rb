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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120821204050) do

  create_table "holidays", :force => true do |t|
    t.date     "holiday_at"
    t.string   "country"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "leaders", :force => true do |t|
    t.string   "identification"
    t.string   "name"
    t.string   "city"
    t.string   "email"
    t.string   "company"
    t.string   "position"
    t.integer  "leader_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "requests", :force => true do |t|
    t.date     "begin_at"
    t.date     "begin_at_approved"
    t.date     "end_at"
    t.date     "end_at_approved"
    t.integer  "days"
    t.integer  "pay_days"
    t.integer  "days_approved"
    t.integer  "pay_days_approved"
    t.text     "comments"
    t.text     "comments_approved"
    t.string   "requester_email"
    t.string   "approver_email"
    t.string   "status"
    t.datetime "requested_at"
    t.datetime "approved_at"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "letter_file"
    t.date     "return_at"
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "roles", ["name", "resource_type", "resource_id"], :name => "index_roles_on_name_and_resource_type_and_resource_id"
  add_index "roles", ["name"], :name => "index_roles_on_name"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "",    :null => false
    t.string   "encrypted_password",     :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.boolean  "admin",                  :default => false
    t.string   "display_name",           :default => ""
    t.string   "identification",         :default => ""
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "users_roles", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], :name => "index_users_roles_on_user_id_and_role_id"

  create_table "vacations", :force => true do |t|
    t.string   "identification"
    t.string   "company"
    t.string   "fullname"
    t.date     "entry_at"
    t.integer  "available_days"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

end
