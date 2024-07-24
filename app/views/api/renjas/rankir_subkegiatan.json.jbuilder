json.message 'Rankir Renja - SubKegiatan - KAK'
json.nama_opd @nama_opd
json.tahun @tahun
json.programs @subkegiatans.each do |subkegiatan|
  json.jenis subkegiatan[:jenis].titleize
  json.kode subkegiatan[:kode_tweak]
  json.nama subkegiatan[:nama]
  json.indikator subkegiatan[:indikators][:indikator]
  json.target subkegiatan[:indikators][:target]
  json.satuan subkegiatan[:indikators][:satuan]
  json.pagu subkegiatan[:pagu]
end
