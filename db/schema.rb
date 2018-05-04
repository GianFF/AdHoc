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

ActiveRecord::Schema.define(version: 20170610171959) do

  create_table "abogados", force: :cascade do |t|
    t.string   "email"
    t.string   "encrypted_password"
    t.string   "nombre"
    t.string   "apellido"
    t.string   "genero"
    t.string   "matricula"
    t.string   "nombre_del_colegio_de_abogados"
    t.string   "cuit"
    t.string   "domicilio_procesal"
    t.string   "domicilio_electronico"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",                default: 0, null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.index ["email"], name: "index_abogados_on_email"
    t.index ["reset_password_token"], name: "index_abogados_on_reset_password_token", unique: true
  end

  create_table "adjuntos", force: :cascade do |t|
    t.text     "titulo",          null: false
    t.string   "archivo_adjunto"
    t.integer  "expediente_id",   null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["expediente_id"], name: "index_adjuntos_on_expediente_id"
  end

  create_table "clientes", force: :cascade do |t|
    t.string   "nombre",             null: false
    t.string   "apellido",           null: false
    t.string   "correo_electronico"
    t.integer  "telefono"
    t.string   "estado_civil"
    t.string   "empresa"
    t.boolean  "trabaja_en_blanco"
    t.integer  "abogado_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.index ["abogado_id"], name: "index_clientes_on_abogado_id"
  end

  create_table "conyuges", force: :cascade do |t|
    t.string   "nombre",     null: false
    t.string   "apellido",   null: false
    t.integer  "cliente_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cliente_id"], name: "index_conyuges_on_cliente_id"
  end

  create_table "direccions", force: :cascade do |t|
    t.string   "calle",      null: false
    t.string   "localidad",  null: false
    t.string   "provincia",  null: false
    t.string   "pais",       null: false
    t.integer  "cliente_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cliente_id"], name: "index_direccions_on_cliente_id"
  end

  create_table "escritos", force: :cascade do |t|
    t.text     "titulo",                          null: false
    t.integer  "expediente_id"
    t.boolean  "presentado",      default: false
    t.text     "cuerpo"
    t.text     "encabezado"
    t.text     "fuero"
    t.text     "fecha_recepcion"
    t.text     "caracter"
    t.text     "observaciones"
    t.text     "nombre"
    t.text     "calle"
    t.text     "nro"
    t.text     "piso"
    t.text     "localidad"
    t.text     "tipo_domicilio"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "type"
    t.index ["expediente_id"], name: "index_escritos_on_expediente_id"
    t.index ["type"], name: "index_escritos_on_type"
  end

  create_table "expedientes", force: :cascade do |t|
    t.text     "actor",                                      null: false
    t.text     "demandado",                                  null: false
    t.text     "materia",                                    null: false
    t.integer  "numero"
    t.integer  "anio"
    t.text     "juzgado"
    t.integer  "numero_de_juzgado"
    t.text     "departamento"
    t.text     "ubicacion_del_departamento"
    t.boolean  "ha_sido_numerado",           default: false
    t.integer  "cliente_id"
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.index ["cliente_id"], name: "index_expedientes_on_cliente_id"
  end

  create_table "hijos", force: :cascade do |t|
    t.string   "nombre",     null: false
    t.string   "apellido",   null: false
    t.integer  "edad",       null: false
    t.integer  "cliente_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cliente_id"], name: "index_hijos_on_cliente_id"
  end

end
