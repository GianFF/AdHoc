class CreateAdjuntos < ActiveRecord::Migration[5.0]
  def change
    create_table :adjuntos do |t|
      t.text :titulo, null: false
      t.string :archivo_adjunto, null: false
      t.references :expediente, foreign_key: true, null: false

      t.timestamps
    end
  end
end
