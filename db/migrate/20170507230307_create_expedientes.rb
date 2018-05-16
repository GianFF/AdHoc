class CreateExpedientes < ActiveRecord::Migration[5.0]
  def change
    create_table :expedientes do |t|
      t.text :actor, null: false
      t.text :demandado, null: false
      t.text :materia, null: false
      t.text :caratula, null: false
      t.integer :numero
      t.integer :anio
      t.text :juzgado
      t.integer :numero_de_juzgado
      t.text :departamento
      t.text :ubicacion_del_departamento
      t.boolean :ha_sido_numerado, default: false

      t.references :cliente, foreign_key: true

      t.timestamps
    end
  end
end
