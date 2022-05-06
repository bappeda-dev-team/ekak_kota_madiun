json.extract! anggaran_hspk, :id, :kode_kelompok_barang, :uraian_kelompok_barang, :kode_barang, :uraian_barang,
              :spesifikasi, :satuan, :harga_satuan, :created_at, :updated_at
json.url anggaran_hspk_url(anggaran_hspk, format: :json)
