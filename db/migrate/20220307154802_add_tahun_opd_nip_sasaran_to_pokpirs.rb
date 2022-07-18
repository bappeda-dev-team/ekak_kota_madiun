class AddTahunOpdNipSasaranToPokpirs < ActiveRecord::Migration[6.1]
  disable_ddl_transaction!

  def change
    add_column :pokpirs, :tahun, :string
    add_column :pokpirs, :opd, :string, null: true
    add_column :pokpirs, :nip_asn, :string, null: true
    add_reference_concurrently :pokpirs, :sasaran, null: true, index: true
  end
end
