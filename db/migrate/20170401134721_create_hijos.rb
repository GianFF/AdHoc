class CreateHijos < ActiveRecord::Migration[5.0]
  def change
    create_table :hijos do |t|
      t.string :nombre, null: false
      t.string :apellido, null: false
      t.integer :edad, null: false
      t.references :cliente, foreign_key: true

      t.timestamps
    end
  end
end
