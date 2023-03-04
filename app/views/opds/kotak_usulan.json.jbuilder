json.results do
  json.id 0
  json.name "Perangkat Daerah"
  json.type "root"
  json.description @nama_opd
  json.tahun @tahun
  if @isu_strategis_kota.any?
    json.children @isu_strategis_kota do |isu_kota|
      json.id isu_kota.id
      json.name "Isu Strategis"
      json.type "isu_strategis"
      json.description isu_kota.isu_strategis
      json.children isu_kota.strategis do |strategi|
        json.id "#{strategi.id}_strategi"
        json.name "Strategi Kota"
        json.type "strategi_kota"
        json.description strategi.strategi
        strategi.strategi_opd(@opd_id).each do |pohon|
          json.children pohon.strategis do |strategic|
            json.id "#{strategic.id}_strategic"
            json.name "Strategic Objective"
            json.type "strategic_objective"
            json.description strategic.strategi_dan_nip
            json.children strategic.strategi_eselon_tigas do |tactical|
              json.id "#{tactical.id}_tactical"
              json.name "Tactical Objective"
              json.type "tactical_objective"
              json.description tactical.strategi_dan_nip
              json.children tactical.strategi_eselon_empats do |operational|
                json.id "#{operational.id}_operational"
                json.name "Operational Objective"
                json.type "operational_objective"
                json.description operational.strategi_dan_nip
                json.children operational.strategi_staffs do |staff|
                  json.id "#{staff.id}_staff"
                  json.name "Operational Objective 2"
                  json.type "operational_2"
                  json.description staff.strategi_dan_nip
                end
              end
            end
          end
        end
      end
    end
  else
    json.children do
      json.id 100
      json.name "Strategic Objective"
      json.type "strategic_objective"
      json.description "Belum Menyusun Pohon Kinerja"
    end
  end
end
