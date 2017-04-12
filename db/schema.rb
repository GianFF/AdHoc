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

ActiveRecord::Schema.define(version: 20170401153346) do

  create_table "clientes", force: :cascade do |t|
    t.string   "nombre"
    t.string   "apellido"
    t.string   "correo_electronico"
    t.integer  "telefono"
    t.string   "estado_civil"
    t.string   "empresa"
    t.boolean  "esta_en_blanco"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "conyuges", force: :cascade do |t|
    t.string   "nombre"
    t.string   "apellido"
    t.integer  "cliente_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "direccions", force: :cascade do |t|
    t.string   "calle"
    t.string   "localidad"
    t.string   "provincia"
    t.string   "pais"
    t.integer  "cliente_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "hijos", force: :cascade do |t|
    t.string   "nombre"
    t.string   "apellido"
    t.integer  "edad"
    t.integer  "cliente_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
