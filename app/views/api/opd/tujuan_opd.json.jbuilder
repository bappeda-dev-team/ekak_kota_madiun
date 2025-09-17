json.results do
  json.message "Data Tujuan OPD - KAK"
  json.description "Data Tujuan OPD 5 Tahunan"
  json.data do
    json.kode_opd @opd.kode_unik_opd
    json.nama_opd @opd.nama_opd
    json.tahun @tahun_bener
    json.tujuan_opd @tujuan_opds do |tujuan|
      json.id_tujuan tujuan.id_tujuan
      json.tujuan tujuan.tujuan
      json.periode tujuan.periode_tujuan
      json.indikator_tujuan tujuan.indikators do |indikator|
        json.id_tujuan indikator.kode
        json.id_indikator indikator.id
        json.indikator indikator.indikator || '-'
        json.rumus_perhitungan indikator.rumus_perhitungan || '-'
        json.sumber_data indikator.sumber_data || '-'
        json.target_tujuan(indikator.targets.filter { |tar| tar.tahun == @tahun_bener }.sort_by(&:tahun)) do |target|
          json.id_indikator target.indikator_id
          json.id_target target.id
          json.tahun target.tahun
          json.target target.target
          json.satuan target&.satuan
        end
      end
    end
  end
end
