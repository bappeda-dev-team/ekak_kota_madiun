json.results do
  json.message 'Strategi Arah Kebijakan'
  json.tahun @tahun
  json.kode_opd @kode_opd
  json.nama_opd @opd.nama_opd
  @strategi_opds.each do |tujuan, strategis|
    json.tujuan_opd tujuan.to_s
    strategis.each do |strategi|
      json.strategi strategi.to_s
      json.kebijakan_list @tactical_opds.select { |tact| tact.pohon_ref_id.to_i == strategi.id }.each do |tactical|
        json.arah_kebijakan tactical.to_s
      end
    end
  end
end
