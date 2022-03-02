json.results @anggaran_sshes do |ssh|
  json.id ssh.kode_kelompok_barang
  json.text ssh.uraian_barang
end
