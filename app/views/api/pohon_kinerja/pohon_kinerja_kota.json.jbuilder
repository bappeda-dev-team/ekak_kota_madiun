json.results do
  json.data do
    json.tahun @tahun
  end
  json.tematik @tema do |tema|
    pohon = PohonKotaPresenter.new(tema)
    json.id tema.id
    json.parent pohon.parent
    json.tema pohon.pohonable.tema
    json.keterangan pohon.keterangan
    json.indikators pohon.indikators do |indikator|
      json.indikator indikator.indikator
      json.target indikator.target
      json.satuan indikator.satuan
    end
  end
  json.sub_tematik @sub_tematiks do |sub_tema|
    pohon = PohonKotaPresenter.new(sub_tema)
    json.id sub_tema.id
    json.parent pohon.parent
    json.tema pohon.pohonable.tema
    json.keterangan pohon.keterangan
    json.indikators pohon.indikators do |indikator|
      json.indikator indikator.indikator
      json.target indikator.target
      json.satuan indikator.satuan
    end
  end
  json.sub_sub_tematik @sub_sub_tematiks do |sub_sub|
    pohon = PohonKotaPresenter.new(sub_sub)
    json.id sub_sub.id
    json.parent pohon.parent
    json.tema pohon.pohonable.tema
    json.keterangan pohon.keterangan
    json.indikators pohon.indikators do |indikator|
      json.indikator indikator.indikator
      json.target indikator.target
      json.satuan indikator.satuan
    end
  end
  json.strategic @strategics do |strategic|
    pohon = PohonKotaPresenter.new(strategic)
    json.id strategic.id
    json.parent strategic.pohon_ref_id
    json.strategi pohon.strategi
    json.keterangan pohon.keterangan
    json.perangkat_daerah pohon.opd
    json.indikators pohon.indikators do |indikator|
      json.indikator indikator.indikator
      json.target indikator.target
      json.satuan indikator.satuan
    end
  end
  json.tactical @tacticals do |tactical|
    pohon = PohonKotaPresenter.new(tactical)
    json.id tactical.id
    json.parent tactical.pohon_ref_id
    json.strategi pohon.pohonable.strategi
    json.keterangan pohon.keterangan
    json.perangkat_daerah pohon.opd
    json.indikators pohon.indikators do |indikator|
      json.indikator indikator.indikator
      json.target indikator.target
      json.satuan indikator.satuan
    end
  end
  json.operational @operationals do |operational|
    pohon = PohonKotaPresenter.new(operational)
    json.id operational.id
    json.parent operational.pohon_ref_id
    json.strategi pohon.pohonable.strategi
    json.keterangan pohon.keterangan
    json.perangkat_daerah pohon.opd
    json.indikators pohon.indikators do |indikator|
      json.indikator indikator.indikator
      json.target indikator.target
      json.satuan indikator.satuan
    end
  end
end
