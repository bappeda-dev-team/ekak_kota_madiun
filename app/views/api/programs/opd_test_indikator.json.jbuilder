json.results @program_kegiatans do |kegiatan|
  json.tahun kegiatan[:tahun]
  json.nama_opd kegiatan[:opd]
  json.kode_opd kegiatan[:kode_opd]
  json.kode_urusan kegiatan[:kode_urusan]
  json.urusan kegiatan[:urusan]
  json.kode_bidang_urusan kegiatan[:kode_bidang_urusan]
  json.bidang_urusan kegiatan[:bidang_urusan]
  json.kode kegiatan[:kode]
  json.nama kegiatan[:nama]
  json.indikators kegiatan[:indikators]
end
