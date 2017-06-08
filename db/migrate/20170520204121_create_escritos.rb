class CreateEscritos < ActiveRecord::Migration[5.0]
  def change
    create_table :escritos do |t|
      t.text :titulo, null: false
      t.text :cuerpo, null: false
      t.text :encabezado
      t.references :expediente, foreign_key: true

      t.timestamps
    end
  end
end
