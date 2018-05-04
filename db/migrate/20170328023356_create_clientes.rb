class CreateClientes < ActiveRecord::Migration[5.0]
  def change
    create_table :clientes do |t|
      t.string  :nombre, null: false
      t.string  :apellido, null: false
      t.string  :correo_electronico
      t.integer :telefono
      t.string  :estado_civil
      t.string  :empresa
      t.boolean :trabaja_en_blanco
      t.references :abogado, foreign_key: true

      t.timestamps
    end
  end
end
