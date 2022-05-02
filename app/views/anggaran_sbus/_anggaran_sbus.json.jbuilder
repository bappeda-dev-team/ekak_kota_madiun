json.extract! anggaran_sbus, :id, :kode_kelompok_barang, :uraian_kelompok_barang, :kode_barang, :uraian_barang,
              :spesifikasi, :satuan, :harga_satuan, :created_at, :updated_at
json.url anggaran_sbus_url(anggaran_sbus, format: :json)
