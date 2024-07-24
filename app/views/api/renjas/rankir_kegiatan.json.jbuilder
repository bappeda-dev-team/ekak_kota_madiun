json.message 'Rankir Renja - Kegiatan - KAK'
json.nama_opd @nama_opd
json.tahun @tahun
json.programs @kegiatans.each do |kegiatan|
  json.jenis kegiatan[:jenis].titleize
  json.kode kegiatan[:kode]
  json.nama kegiatan[:nama]
  json.indikator kegiatan[:indikators][:indikator]
  json.target kegiatan[:indikators][:target]
  json.satuan kegiatan[:indikators][:satuan]

  pagu = @subkegiatans
         .select { |prs| prs[:parent] == kegiatan[:kode] && prs[:kode_sub_opd] == kegiatan[:kode_opd] }
         .sum { |sub| sub[:pagu] }
  json.pagu pagu
end
