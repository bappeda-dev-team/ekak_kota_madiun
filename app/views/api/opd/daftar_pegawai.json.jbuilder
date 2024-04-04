json.status @users.any?
json.pesan "Data Pegawai All"
json.data @users do |user|
  json.nip user.nip_asn
  json.nama user.nama
  json.jabatan user.nama_jabatan_terakhir
  json.eselon user.eselon
  json.namapangkat user.nama_pangkat.to_s
  json.pangkat user.pangkat
  json.status user.status_kepegawaian
  json.unit_id user.opd.kode_unik_opd
  json.unit_name user.opd.nama_opd
  json.id_sipd user.opd.id_opd_skp
  json.tahun user.tahun_jabatan
end
