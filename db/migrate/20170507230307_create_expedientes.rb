class CreateExpedientes < ActiveRecord::Migration[5.0]
  def change
    create_table :expedientes do |t|
      t.text :actor
      t.text :demandado
      t.text :materia

      t.timestamps
    end
  end
end
