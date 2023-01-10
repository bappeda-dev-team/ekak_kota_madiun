json.message "Data Indikator Sasaran Kinerja ASN - KAK"
json.data do
  json.nama_asn @user.nama
  json.nip @nip
  json.tahun @tahun
  json.kode_opd @user.opd.kode_unik_opd
  json.opd @user.opd.nama_opd
  json.id_sasaran @sasaran.id_rencana
  json.sasaran @sasaran.sasaran_kinerja
  json.anggaran @sasaran.total_anggaran
  json.indikator_sasaran @indikators do |indikator_sasaran|
    json.id_indikator indikator_sasaran.id
    json.id_sasaran indikator_sasaran.sasaran_id
    json.indikator indikator_sasaran.indikator_kinerja
    json.target indikator_sasaran.target
    json.satuan indikator_sasaran.satuan
  end
end
