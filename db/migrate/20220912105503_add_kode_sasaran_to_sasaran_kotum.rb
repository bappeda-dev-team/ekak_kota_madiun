class AddKodeSasaranToSasaranKotum < ActiveRecord::Migration[6.1]
  def change
    add_column :sasaran_kota, :kode_sasaran, :string
  end
end
