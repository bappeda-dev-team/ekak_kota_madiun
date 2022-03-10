json.results @anggaran_sshes do |ssh|
  json.id ssh.kode_barang
  json.text ssh.class.name + '|' + ssh.uraian_barang + ' | ' + ssh.spesifikasi
  json.spesifikasi ssh.spesifikasi
  json.satuan ssh.satuan
  json.harga ssh.harga_satuan
end
