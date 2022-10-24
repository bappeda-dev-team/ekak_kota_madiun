json.nama_opd @opd.nama_opd
json.kode_opd @kode_opd
json.jumlah @program_kegiatans.size
json.set! "results", @program_kegiatans
# json.results @program_kegiatans do |kegiatan|
#   json.jenis kegiatan[:jenis]
#   json.tahun kegiatan[:tahun]
#   json.kode_urusan kegiatan[:kode_urusan]
#   json.urusan kegiatan[:urusan]
#   json.kode_bidang_urusan kegiatan[:kode_bidang_urusan]
#   json.bidang_urusan kegiatan[:bidang_urusan]
#   json.kode_program kegiatan[:kode_program]
#   json.kode_kegiatan kegiatan[:kode_kegiatan]
#   json.kode_subkegiatan kegiatan[:kode_subkegiatan]
#   json.kode kegiatan[:kode]
#   json.nama kegiatan[:nama]
#   json.jumlah_indikator kegiatan[:indikators].size
#   json.indikators kegiatan[:indikators]
# end
