class AddTahunOpdNipSasaranToMandatoris < ActiveRecord::Migration[6.1]
  def change
    add_column :mandatoris, :tahun, :string
    add_column :mandatoris, :opd, :string, null: true
    add_column :mandatoris, :nip_asn, :string, null: true
    add_reference :mandatoris, :sasaran, null: true, index: true
  end
end
