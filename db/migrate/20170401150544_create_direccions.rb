class CreateDireccions < ActiveRecord::Migration[5.0]
  def change
    create_table :direccions do |t|
      t.string :calle, null: false
      t.string :localidad, null: false
      t.string :provincia, null: false
      t.string :pais, null: false
      t.references :cliente, foreign_key: true

      t.timestamps
    end
  end
end
