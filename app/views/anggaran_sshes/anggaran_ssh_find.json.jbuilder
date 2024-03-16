json.results @anggaran_sshes do |ssh|
  json.id ssh.searchable_id
  json.kode_barang ssh.kode_barang
  json.text "#{ssh.searchable_type} #{ssh.tahun} |  #{ssh.uraian_barang} | #{ssh.spesifikasi} | Rp. #{number_with_delimiter(ssh.harga_satuan)}"
  json.spesifikasi ssh.spesifikasi
  json.satuan ssh.satuan
  json.harga ssh.harga_satuan
  json.barang_id ssh.searchable_id
end
