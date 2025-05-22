json.message "Data Sasaran Kinerja ASN - KAK"
json.data do
  json.nama_asn @user.nama
  json.nip @nip
  json.tahun @tahun
  json.kode_opd @user.opd.kode_unik_opd
  json.opd @user.opd.nama_opd
  json.jumlah_sasaran @sasarans.size
  json.sasaran_asn @sasarans do |sasaran|
    json.id_sasaran sasaran.id_rencana
    json.tahun_sasaran sasaran.tahun
    json.nip_asn sasaran.nip_asn
    json.jenis_strategi sasaran&.strategi&.role
    json.strategi sasaran&.strategi&.strategi
    json.sasaran sasaran.sasaran_kinerja
    json.is_perintah_walikota sasaran.perintah_walikota?
    json.is_sasaran_prioritas sasaran.termasuk_program_unggulan?
    if sasaran.inovasi_lolos?
      json.terdapat_inovasi sasaran.punya_inovasi?
      json.inovasi_lolos sasaran.inovasi_lolos?
      json.inovasi_sasaran sasaran.sasaran_inovasi
      json.hasil_inovasi_sasaran sasaran.sasaran_hasil_inovasi
      json.jenis_inovasi_sasaran sasaran.sasaran_jenis_inovasi
      json.gambaran_inovasi_sasaran sasaran.sasaran_gambaran_inovasi
    else
      json.terdapat_inovasi false
      json.inovasi_lolos sasaran.inovasi_lolos?
      json.inovasi_sasaran ''
      json.hasil_inovasi_sasaran ''
      json.jenis_inovasi_sasaran ''
      json.gambaran_inovasi_sasaran ''
    end
    json.jumlah_indikator sasaran.indikator_sasarans.size
    json.indikator_sasaran sasaran.indikator_sasarans do |indikator_sasaran|
      json.id_indikator indikator_sasaran.id
      json.id_sasaran indikator_sasaran.sasaran_id
      json.indikator indikator_sasaran.indikator_kinerja
      json.target indikator_sasaran.target
      json.satuan indikator_sasaran.satuan
    end
  end
end
