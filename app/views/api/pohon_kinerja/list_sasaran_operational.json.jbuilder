json.results @sasarans do |sasaran|
  json.id sasaran.id
  json.kode_sasaran sasaran.id_rencana
  json.tahun_sasaran sasaran.tahun
  json.id_strategi_operational sasaran.strategi.id
  json.strategi_operational sasaran.strategi.strategi
  json.sasaran sasaran.sasaran_kinerja
  json.anggaran_sasaran sasaran.total_anggaran
  json.pelaksana_sasaran sasaran.nama_pelaksana
  json.kode_subkegiatan_sasaran sasaran.kode_subkegiatan
  json.subkegiatan_sasaran sasaran.subkegiatan
end
