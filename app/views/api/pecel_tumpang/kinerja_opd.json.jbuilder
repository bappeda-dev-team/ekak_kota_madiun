json.results do
  json.tahun @tahun
  json.nama_opd @nama_opd
  json.list_kinerja_opd @list_kinerja_opd do |kinerja|
    json.sasaran kinerja.sasaran_kinerja
    json.indikator_sasaran kinerja.indikator_sasarans do |indikator|
      json.indikator indikator.indikator_kinerja
      json.target indikator.target
      json.satuan indikator.satuan
      json.sumber_data indikator.sumber_data
      json.output_data indikator.output_data
    end
  end
end
