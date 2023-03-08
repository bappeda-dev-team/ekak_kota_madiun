json.results do
  json.id 0
  json.name "Kota"
  json.type "root"
  json.description "Kota Madiun"
  json.tahun @tahun
  if @isu_strategis_kota.any?
    json.children @isu_strategis_kota do |isu_kota|
      json.id isu_kota.id
      json.name "Isu Strategis"
      json.type "isu_strategis_kota"
      json.description isu_kota.isu_strategis
      json.children isu_kota.strategi_kotums do |strategi_kota|
        json.id strategi_kota.id
        json.name "Strategi"
        json.type "strategi_kota"
        json.description strategi_kota.strategi
        json.children strategi_kota.pohons do |pohon|
          json.id pohon.opd.id
          json.name pohon.opd.nama_opd
          json.type "perangkat_daerah"
          json.description pohon.opd.strategi_kepala_by_strategi_kota(pohon.pohonable_id)
        end
      end
    end
  else
    json.children do
      json.id 1
      json.name "Isu Strategis"
      json.type "isu_strategis_kota"
      json.description "Isu Strategis Kota Kosong"
    end
  end
end
