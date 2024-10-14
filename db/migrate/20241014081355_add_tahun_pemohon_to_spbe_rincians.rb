class AddTahunPemohonToSpbeRincians < ActiveRecord::Migration[6.1]
  def change
    add_column :spbe_rincians, :tahun_awal_pemohon, :string
    add_column :spbe_rincians, :tahun_akhir_pemohon, :string
  end
end
