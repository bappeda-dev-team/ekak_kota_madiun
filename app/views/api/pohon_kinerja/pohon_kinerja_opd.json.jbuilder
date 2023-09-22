json.results do
  json.data do
    json.tahun @tahun
    json.kode_opd @kode_opd
    json.nama_opd @opd.nama_opd
  end
  json.strategic @strategi_opd do |strategic|
    pohon = PohonKinerjaPresenter.new(strategic)
    json.id strategic.id
    json.parent strategic.pohon_ref_id
    json.strategi pohon.pohonable.strategi
    json.keterangan pohon.keterangan
    json.perangkat_daerah pohon.pohonable.opd
    json.indikators pohon.indikators do |indikator|
      json.indikator indikator
      json.target indikator.target
      json.satuan indikator.satuan
    end
  end
  json.tactical @tactical_opd do |tactical|
    pohon = PohonKinerjaPresenter.new(tactical)
    json.id tactical.id
    json.parent tactical.pohon_ref_id
    json.strategi pohon.pohonable.strategi
    json.keterangan pohon.keterangan
    json.perangkat_daerah pohon.pohonable.opd
    json.indikators pohon.indikators do |indikator|
      json.indikator indikator
      json.target indikator.target
      json.satuan indikator.satuan
    end
  end
  json.operational @operational_opd do |operational|
    pohon = PohonKinerjaPresenter.new(operational)
    json.id operational.id
    json.parent operational.pohon_ref_id
    json.strategi pohon.pohonable.strategi
    json.keterangan pohon.keterangan
    json.perangkat_daerah pohon.pohonable.opd
    json.indikators pohon.indikators do |indikator|
      json.indikator indikator
      json.target indikator.target
      json.satuan indikator.satuan
    end
  end
  json.staff @staff_opd do |staff|
    pohon = PohonKinerjaPresenter.new(staff)
    json.id staff.id
    json.parent staff.pohon_ref_id
    json.strategi pohon.pohonable.strategi
    json.keterangan pohon.keterangan
    json.perangkat_daerah pohon.pohonable.opd
    json.indikators pohon.indikators do |indikator|
      json.indikator indikator
      json.target indikator.target
      json.satuan indikator.satuan
    end
  end
end
