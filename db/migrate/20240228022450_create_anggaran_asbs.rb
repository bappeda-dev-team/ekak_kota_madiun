class CreateAnggaranAsbs < ActiveRecord::Migration[6.1]
  def change
    create_table :anggaran_asbs do |t|
      t.bigint :harga_satuan
      t.string :id_standar_harga
      t.string :kode_barang
      t.string :kode_kelompok_barang
      t.string :satuan
      t.string :spesifikasi
      t.string :tahun
      t.string :uraian_barang
      t.string :uraian_kelompok_barang
      t.bigint :opd_id

      t.timestamps
    end
  end
end
