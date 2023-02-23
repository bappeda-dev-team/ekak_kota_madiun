class AddStrategiToSasarans < ActiveRecord::Migration[6.1]
  def change
    add_column :sasarans, :strategi_id, :string, null: true
  end
end
