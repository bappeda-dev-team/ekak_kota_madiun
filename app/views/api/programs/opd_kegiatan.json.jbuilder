json.results @program_kegiatans do |kegiatan|
  json.tahun kegiatan.tahun
  json.kode_kegiatan kegiatan.kode_giat
  json.kegiatan kegiatan.nama_kegiatan
  json.indikator_kegiatan kegiatan.indikator_kinerja
  json.target kegiatan.target
  json.satuan kegiatan.satuan
  json.kode_opd kegiatan.opd.kode_unik_opd
end
