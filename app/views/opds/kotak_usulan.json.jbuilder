json.results do
  json.id 0
  json.name "Perangkat Daerah"
  json.type "root"
  json.description @nama_opd
  json.tahun @tahun
  if @isu_strategis_pohon.any?
    json.children @isu_strategis_pohon do |isu_kota|
      json.id isu_kota.id
      json.name isu_kota.instance_of?(IsuStrategisOpd) ? "Isu Strategis OPD" : "Isu Strategis Kota"
      json.type isu_kota.instance_of?(IsuStrategisOpd) ? "isu_strategis_opd" : "isu_strategis_kota"
      json.description isu_kota.isu_strategis

      isu_asli = isu_kota.instance_of?(IsuStrategisOpd) ? isu_kota.pohons : isu_kota.strategis(@opd_id)

      json.children isu_asli do |strategi|
        json.id "#{strategi.id}_strategi"
        json.name strategi.instance_of?(Pohon) ? "Strategi OPD" : "Strategi Kota"
        json.type strategi.instance_of?(Pohon) ? "strategi_opd" : "strategi_kota"

        strategi_deskripsi = strategi.instance_of?(Pohon) ? strategi.pohonable.strategi : strategi.strategi

        json.description strategi_deskripsi

        if strategi.instance_of?(Pohon)
          json.children strategi.strategis do |strategic|
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
        else
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
