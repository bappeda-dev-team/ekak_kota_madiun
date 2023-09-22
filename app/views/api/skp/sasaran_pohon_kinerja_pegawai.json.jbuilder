json.message "Data Sasaran Kinerja ASN Pohon Kinerja - KAK"
json.data do
  json.nama_asn @user.nama
  json.nip @nip
  json.tahun @tahun
  json.kode_opd @user.opd.kode_unik_opd
  json.opd @user.opd.nama_opd
  json.jumlah_sasaran @sasarans.size
  json.sasaran_asn @sasarans do |sasaran|
    json.id_sasaran sasaran.id_rencana

    json.id_sasaran_kota sasaran.sasaran_kota[:sasaran_kota_id]
    json.sasaran_kota sasaran.sasaran_kota[:sasaran_kota]
    json.strategi_kota sasaran.sasaran_kota[:strategi_kota]

    json.id_sasaran_atasan sasaran.sasaran_atasan_pohon[:sasaran_atasan_id]
    json.sasaran_atasan sasaran.sasaran_atasan_pohon[:sasaran_atasan]

    json.tahun_sasaran sasaran.tahun
    json.nip_asn sasaran.nip_asn
    json.sasaran sasaran.sasaran_kinerja
    json.status sasaran.status_ekak
  end
end
