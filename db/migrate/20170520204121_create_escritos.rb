class CreateEscritos < ActiveRecord::Migration[5.0]
  def change
    create_table :escritos do |t|
      t.text :titulo, null: false
      t.references :expediente, foreign_key: true
      t.boolean :presentado, default: false

      # Meros Tramites, Demandas, Contestaciones de Demandas:
      t.text :cuerpo
      t.text :encabezado

      # Notificaciones
      t.text :fuero
      t.text :fecha_recepcion
      t.text :caracter
      t.text :observaciones
      #   Datos del cliente
      t.text :nombre
      t.text :calle
      t.text :nro
      t.text :piso
      t.text :localidad
      t.text :tipo_domicilio

      t.timestamps
    end
  end
end
