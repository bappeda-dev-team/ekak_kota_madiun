json.results do
  json.message "Data Sasaran OPD - KAK"
  json.description "Data Sasaran OPD Tahun #{@tahun}"
  json.data do
    json.kode_opd @opd.kode_unik_opd
    json.nama_opd @opd.nama_opd
    json.sasaran_opds @sasaran_opds do |sasaran|
      json.id sasaran.id
      json.id_sasaran sasaran.id_rencana
      json.tahun sasaran.tahun
      json.sasaran_opd sasaran.sasaran_kinerja
      json.indikator_sasaran sasaran.indikator_sasarans do |indikator|
        json.id indikator.id
        json.id_sasaran indikator.sasaran_id
        json.indikator indikator.indikator_kinerja
        json.target indikator.target
        json.satuan indikator.satuan
        json.tahun sasaran.tahun
      end
    end
  end
end
