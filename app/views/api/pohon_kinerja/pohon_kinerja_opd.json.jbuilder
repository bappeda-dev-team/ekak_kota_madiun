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
    json.jenis_pohon 'Strategic'
    json.level_pohon 4
    json.strategi pohon.pohonable.strategi
    json.keterangan pohon.keterangan
    json.nama_opd pohon.pohonable.opd.nama_opd
    json.kode_opd pohon.pohonable.opd.kode_unik_opd
  end
  json.tactical @tactical_opd do |tactical|
    pohon = PohonKinerjaPresenter.new(tactical)
    json.id tactical.id
    json.parent tactical.pohon_ref_id
    json.jenis_pohon 'Tactical'
    json.level_pohon 5
    json.strategi pohon.pohonable.strategi
    json.keterangan pohon.keterangan
    json.nama_opd pohon.pohonable.opd.nama_opd
    json.kode_opd pohon.pohonable.opd.kode_unik_opd
  end
  json.operational @operational_opd do |operational|
    pohon = PohonKinerjaPresenter.new(operational)
    json.id operational.id
    json.parent operational.pohon_ref_id
    json.jenis_pohon 'Operational'
    json.level_pohon 6
    json.strategi pohon.pohonable.strategi
    json.keterangan pohon.keterangan
    json.nama_opd pohon.pohonable.opd.nama_opd
    json.kode_opd pohon.pohonable.opd.kode_unik_opd
  end
  json.staff @staff_opd do |staff|
    pohon = PohonKinerjaPresenter.new(staff)
    json.id staff.id
    json.parent staff.pohon_ref_id
    json.jenis_pohon 'Staff'
    json.level_pohon 7
    json.strategi pohon.pohonable.strategi
    json.keterangan pohon.keterangan
    json.nama_opd pohon.pohonable.opd.nama_opd
    json.kode_opd pohon.pohonable.opd.kode_unik_opd
  end
end
