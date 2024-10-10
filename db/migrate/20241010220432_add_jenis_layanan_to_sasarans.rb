class AddJenisLayananToSasarans < ActiveRecord::Migration[6.1]
  def change
    add_column :sasarans, :jenis_layanan, :string
  end
end
