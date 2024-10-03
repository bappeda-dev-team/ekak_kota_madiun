json.message 'Sumber Daya Manusia'
json.tahun @tahun
json.kode_opd @kode_opd
json.nama_opd @opd.nama_opd
json.sumber_daya_manusia @jabatans.each do |jabatan|
  json.nama_jabatan jabatan.nama_jabatan
  json.jenis_jabatan jabatan.nama_jenis_jabatan
  json.status_jumlah_kepegawaian jabatan.jumlah_status_kepegawaian(@tahun)
  json.pendidikan_terakhir jabatan.jumlah_pendidikan(@tahun)
end
