json.message 'Strategi Arah Kebijakan'
json.tahun @tahun
json.kode_opd @kode_opd
json.nama_opd @opd.nama_opd
@strategi_opds.each do |tujuan, strategis|
  json.tujuan_opd tujuan.to_s
  if tujuan.present?
    tujuan.indikators.each do |indikator|
      json.indikator_tujuan indikator.targets.each do |target|
        json.indikator indikator.to_s
        json.target target.target
        json.satuan target.satuan
        json.tahun target.tahun
      end
    end
  end
  strategis.each do |strategi|
    json.strategi strategi.to_s
    json.indikator_strategi strategi.indikators.each do |indikator|
      json.indikator indikator.to_s
      json.target indikator.target
      json.satuan indikator.satuan
    end
    json.sasaran_opd_list strategi.sasarans.dengan_nip.each do |sasaran|
      json.sasaran_opd sasaran.to_s
      json.indikator_sasaran sasaran.indikator_sasarans.each do |indikator|
        json.indikator indikator.to_s
        json.target indikator.target
        json.satuan indikator.satuan
      end
    end
    json.kebijakan_list @tactical_opds.select { |tact| tact.pohon_ref_id.to_i == strategi.id }.each do |tactical|
      json.arah_kebijakan tactical.to_s
    end
  end
end
