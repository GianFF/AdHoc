class CreateExpedientes < ActiveRecord::Migration[5.0]
  def change
    create_table :expedientes do |t|
      t.text :actor
      t.text :demandado
      t.text :materia
      t.integer :numero
      t.integer :anio
      t.text :juzgado
      t.integer :numero_de_juzgado
      t.text :departamento
      t.text :ubicacion_del_departamento
      t.boolean :ha_sido_numerado

      t.integer :cliente_id

      t.timestamps
    end
  end
end
