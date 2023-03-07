json.message "Data Manual IK ASN - KAK"
json.data do
  json.nama_asn @user.nama
  json.nip @nip
  json.tahun @tahun
  json.kode_opd @user.opd.kode_unik_opd
  json.opd @user.opd.nama_opd
  json.sasaran @sasaran.sasaran_kinerja
  json.id_indikator @indikator_sasaran.id
  json.indikator @indikator_sasaran.indikator_kinerja
  json.manual_ik do
    json.partial! partial: 'manual_ik_item', locals: {manual_ik: @indikator_sasaran.manual_ik}
  end
end
