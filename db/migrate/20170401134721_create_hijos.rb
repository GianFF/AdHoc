class CreateHijos < ActiveRecord::Migration[5.0]
  def change
    create_table :hijos do |t|
      t.string :nombre
      t.string :apellido
      t.string :apellido
      t.integer :edad
      t.integer :cliente_id

      t.timestamps
    end
  end
end
