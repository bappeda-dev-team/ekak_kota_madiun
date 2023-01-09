json.message "Data Sasaran Kinerja ASN - KAK"
json.data do
  json.nama_asn @user.nama
  json.nip @nip
  json.tahun @tahun
  json.jumlah_sasaran @sasarans.size
  json.sasaran_asn @sasarans do |sasaran|
    json.tahun_sasaran sasaran.tahun
    json.sasaran sasaran.sasaran_kinerja
    json.anggaran sasaran.total_anggaran
    json.jumlah_indikator sasaran.indikator_sasarans.size
    json.jumlah_rencana_aksi sasaran.tahapans.size
    json.indikator_sasaran sasaran.indikator_sasarans do |indikator_sasaran|
      json.indikator indikator_sasaran.indikator_kinerja
      json.target indikator_sasaran.target
      json.satuan indikator_sasaran.satuan
    end
    json.rencana_aksi sasaran.tahapans do |renaksi|
      json.tahapan_kerja renaksi.tahapan_kerja
      json.anggaran_tahapan renaksi.anggaran_tahapan
      json.aksis renaksi.aksis do |aksi|
        json.bulan aksi.bulan
        json.target aksi.target
      end
    end
    json.manual_ik do
      json.rencana_hasil_kerja sasaran.sasaran_kinerja
      json.tujuan_rencana_hasil_kerja sasaran.gambaran_umum_sasaran
      json.jenis_indikator_kinerja 'Output'
    end
    json.tematik_sasaran sasaran.tematik_sasarans do |tematik|
      json.nama_tematik tematik.subkegiatan_tematik.nama_tematik
    end
  end
end
