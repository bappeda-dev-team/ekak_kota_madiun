json.results @anggaran_hspks do |hspk|
  json.id hspk.kode_barang
  json.text "#{hspk.class.name} #{hspk.tahun || '2022'} |  #{hspk.uraian_barang} | #{hspk.spesifikasi} | Rp. #{number_with_delimiter(hspk.harga_satuan, delimiter: '.')}"
  json.uraian_barang hspk.uraian_barang
  json.spesifikasi hspk.spesifikasi
  json.satuan hspk.satuan
  json.harga hspk.harga_satuan
end
