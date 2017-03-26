class CreateConyuges < ActiveRecord::Migration[5.0]
  def change
    create_table :conyuges do |t|
      t.string :nombre
      t.string :apellido
      t.integer :cliente_id

      t.timestamps
    end
  end
end
