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
    json.sasaran sasaran.sasaran_kinerja
    json.jumlah_indikator sasaran.indikator_sasarans.size
    json.jumlah_rencana_aksi sasaran.tahapans.size
    json.indikator_sasaran sasaran.indikator_sasarans do |indikator_sasaran|
      json.id_indikator indikator_sasaran.id
      json.id_sasaran indikator_sasaran.sasaran_id
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
    json.tematik_sasaran sasaran.tematik_sasarans do |tematik|
      json.id_sasaran sasaran.id_rencana
      json.kode_tematik tematik.subkegiatan_tematik.kode_tematik
      json.nama_tematik tematik.subkegiatan_tematik.nama_tematik
    end
  end
end
