json.results @data_anggarans do |ssh|
  json.id ssh.kode_barang
  json.tahun ssh.tahun
  json.text "#{ssh.class.name} #{ssh.tahun || '2022'} |  #{ssh.uraian_barang} | #{ssh.spesifikasi} | Rp. #{number_with_delimiter(
    ssh.harga_satuan, delimiter: '.'
  )}"
  json.spesifikasi ssh.spesifikasi
  json.satuan ssh.satuan
  json.harga ssh.harga_satuan
end
