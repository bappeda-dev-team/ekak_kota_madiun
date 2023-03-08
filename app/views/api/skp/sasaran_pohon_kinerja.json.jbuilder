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
    json.strategi sasaran&.strategi&.strategi
    json.sasaran sasaran.sasaran_kinerja

    json.jumlah_indikator sasaran.indikator_sasarans.size
    json.jumlah_rencana_aksi sasaran.tahapans.size
    json.indikator_sasaran sasaran.indikator_sasarans do |indikator_sasaran|
      json.id_indikator indikator_sasaran.id
      json.id_sasaran indikator_sasaran.sasaran_id
      json.aspek indikator_sasaran.aspek
      json.indikator indikator_sasaran.indikator_kinerja
      json.target indikator_sasaran.target
      json.satuan indikator_sasaran.satuan
      json.manual_ik do
        json.partial! partial: 'manual_ik_item', locals: {manual_ik: indikator_sasaran.manual_ik}
      end
    end
    json.rencana_aksi sasaran.tahapans do |renaksi|
      json.id_tahapan renaksi.id_rencana_aksi
      json.id_sasaran renaksi.id_rencana
      json.tahapan_kerja renaksi.tahapan_kerja
      json.anggaran_tahapan renaksi.anggaran_tahapan
      json.created_at renaksi.created_at
      json.aksis renaksi.aksis do |aksi|
        json.id_aksi aksi.id
        json.id_tahapan aksi.id_rencana_aksi
        json.bulan aksi.bulan
        json.target aksi.target
      end
    end
  end
end
