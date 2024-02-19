json.extract! aset, :id, :nama_aset, :jumlah, :satuan, :kondisi, :tahun_awal, :tahun_akhir, :keterangan, :created_at, :updated_at
json.url aset_url(aset, format: :json)
