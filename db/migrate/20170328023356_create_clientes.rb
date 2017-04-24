class CreateClientes < ActiveRecord::Migration[5.0]
  def change
    create_table :clientes do |t|
      t.string  :nombre
      t.string  :apellido
      t.string  :correo_electronico
      t.integer :telefono
      t.string  :estado_civil
      t.string  :empresa
      t.boolean :esta_en_blanco
      t.integer :abogado_id

      t.timestamps
    end
  end
end
