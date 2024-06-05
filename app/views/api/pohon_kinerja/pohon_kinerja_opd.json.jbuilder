json.results do
  json.data do
    json.tahun @tahun
    json.kode_opd @kode_opd
    json.nama_opd @opd.nama_opd
    json.pohon_kinerjas @pohons do |pokin|
      pohon = PohonKinerjaPresenter.new(pokin)
      jenis = case pokin.role
              when 'eselon_2'
                'Strategic'
              when 'eselon_3'
                'Tactical'
              when 'eselon_4'
                'Operational'
              else
                '-'
              end
      level = case pokin.role
              when 'eselon_2'
                4
              when 'eselon_3'
                5
              when 'eselon_4'
                6
              else
                0
              end
      json.id pokin.id
      json.parent pokin.pohon_ref_id
      json.jenis_pohon jenis
      json.level_pohon level
      json.strategi pohon.pohonable.strategi
    end
  end
end
