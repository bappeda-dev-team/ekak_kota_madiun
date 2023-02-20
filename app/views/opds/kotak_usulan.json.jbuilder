json.results do
  json.id 0
  json.name "Pohon Kinerja"
  json.type "root"
  json.description @nama_opd
  json.tahun @tahun
  if @kotak_usulan.any?
    json.children @kotak_usulan do |kotak_opd|
      json.id kotak_opd.id
      json.name "Strategic Objective"
      json.type "strategic_objective"
      json.description kotak_opd.isu_strategis
      json.children isu_kota.strategi_kotums do |strategi_kota|
        json.id strategi_kota.id
        json.name "Strategi"
        json.type "strategi_kota"
        json.description strategi_kota.strategi
        json.children strategi_kota.usulans do |opd|
          json.id opd.id
          json.name "Perangkat Daerah"
          json.type "perangkat_daerah"
          json.description opd.keterangan
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
