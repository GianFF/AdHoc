class AddTypeToEscritos < ActiveRecord::Migration[5.0]
  def change
    add_column :escritos, :type, :string
    add_index :escritos, :type
  end
end
