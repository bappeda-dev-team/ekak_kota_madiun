json.results @anggaran_sshes do |ssh|
  json.id ssh.id
  json.kode_barang ssh.kode_barang
  json.text "#{ssh.class.name} #{ssh.tahun} |  #{ssh.uraian_barang} | #{ssh.spesifikasi} | Rp. #{number_with_delimiter(ssh.harga_satuan)}"
  json.spesifikasi ssh.spesifikasi
  json.satuan ssh.satuan
  json.harga ssh.harga_satuan
  json.barang_id ssh.id
end
