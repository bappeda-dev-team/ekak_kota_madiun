class AddTahunOpdNipSasaranToInovasis < ActiveRecord::Migration[6.1]
  disable_ddl_transaction!
  
  def change
    add_column :inovasis, :tahun, :string
    add_column :inovasis, :opd, :string, null: true
    add_column :inovasis, :nip_asn, :string, null: true
    add_reference_concurrently :inovasis, :sasaran, null: true, index: true
  end
end
