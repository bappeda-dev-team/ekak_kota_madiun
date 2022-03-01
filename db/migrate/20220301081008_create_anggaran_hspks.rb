class CreateAnggaranHspks < ActiveRecord::Migration[6.1]
  def change
    create_table :anggaran_hspks do |t|
      t.string :kode_kelompok_barang
      t.string :uraian_kelompok_barang
      t.string :kode_barang
      t.string :uraian_barang
      t.string :spesifikasi
      t.string :satuan
      t.bigint :harga_satuan

      t.timestamps
    end
  end
end
