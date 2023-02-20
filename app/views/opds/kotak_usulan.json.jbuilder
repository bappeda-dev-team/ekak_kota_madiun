json.results do
  json.id 0
  json.name "Pohon Kinerja"
  json.type "root"
  json.description @nama_opd
  json.tahun @tahun
  if @pohons.any?
    json.children @pohons do |pohon|
      json.id pohon.id
      json.name "Isu Strategis"
      json.type "isu_strategis"
      json.description pohon.keterangan + ' jenis: ' + pohon.pohonable_type
      json.children pohon.strategis do |strategi|
        json.id strategi.id
        json.name "Strategic Objective"
        json.type "strategic_objective"
        json.description strategi.strategi
      end
    end
  else
    json.children do
      json.id 1
      json.name "Strategic Objective"
      json.type "strategic_objective"
      json.description "Belum Menyusun Pohon Kinerja"
    end
  end
end
