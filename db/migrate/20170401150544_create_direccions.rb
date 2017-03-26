#TODO: ver si se le puede cambiar el nombre a "CrearDirecciones"

class CreateDireccions < ActiveRecord::Migration[5.0]
  def change
    create_table :direccions do |t|
      t.string :calle
      t.string :localidad
      t.string :provincia
      t.string :pais
      t.integer :cliente_id

      t.timestamps
    end
  end
end
