class AddTahunAndIdentifierToAnggaranSshDll < ActiveRecord::Migration[6.1]
  def change
    add_column :anggaran_sshes, :tahun, :string, null: true
    add_column :anggaran_sbus, :tahun, :string, null: true
    add_column :anggaran_hspks, :tahun, :string, null: true
    add_column :anggaran_bluds, :tahun, :string, null: true
    # identifier
    add_column :anggaran_sshes, :id_standar_harga, :string, null: true
    add_column :anggaran_sbus, :id_standar_harga, :string, null: true
    add_column :anggaran_hspks, :id_standar_harga, :string, null: true
  end
end
