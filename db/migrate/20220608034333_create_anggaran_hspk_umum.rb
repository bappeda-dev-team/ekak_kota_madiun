class CreateAnggaranHspkUmum < ActiveRecord::Migration[6.1]
  def change
    create_table :anggaran_hspk_umums do |t|
      t.string :kode_kelompok_barang
      t.string :uraian_kelompok_barang
      t.string :kode_barang
      t.string :uraian_barang
      t.string :spesifikasi
      t.string :satuan
      t.bigint :harga_satuan
      t.string :tahun, null: true
      t.string :id_standar_harga, null: true

      t.timestamps
    end
  end
end
