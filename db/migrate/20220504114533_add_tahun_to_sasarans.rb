class AddTahunToSasarans < ActiveRecord::Migration[6.1]
  def change
    add_column :sasarans, :tahun, :string, null: true
  end
end
