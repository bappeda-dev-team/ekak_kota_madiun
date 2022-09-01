json.results @program_kegiatans do |subkegiatan|
  json.tahun subkegiatan.tahun
  json.kode_subkegiatan subkegiatan.kode_sub_giat
  json.subkegiatan subkegiatan.nama_subkegiatan
  json.indikator_subkegiatan subkegiatan.indikator_subkegiatan
  json.target subkegiatan.target_subkegiatan
  json.satuan subkegiatan.satuan_target_subkegiatan
  json.kode_opd subkegiatan.opd.kode_unik_opd
end
