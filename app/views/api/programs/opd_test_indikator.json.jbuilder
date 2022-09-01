json.results @program_kegiatans do |kegiatan|
  json.tahun kegiatan[:tahun]
  json.nama_opd kegiatan[:opd]
  json.kode_opd kegiatan[:kode_opd]
  json.kode_kegiatan kegiatan[:kode]
  json.kegiatan kegiatan[:nama]
  json.indikator kegiatan[:indikator]
end
