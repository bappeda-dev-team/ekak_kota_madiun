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
    json.id_manual_ik @indikator_sasaran.id
    json.rencana_hasil_kerja @sasaran.sasaran_kinerja
    json.tujuan_rencana_hasil_kerja @sasaran.gambaran_umum_sasaran
    json.indikator_kinerja "#{@indikator_sasaran.indikator_kinerja} | #{@indikator_sasaran.target} #{@indikator_sasaran.satuan}"
    json.satuan_pengukuran @indikator_sasaran.satuan
    json.jenis_indikator_kinerja 'Output'
  end
end
