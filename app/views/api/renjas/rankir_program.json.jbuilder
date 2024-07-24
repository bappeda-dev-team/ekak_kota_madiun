json.message 'Rankir Renja - Program - KAK'
json.nama_opd @nama_opd
json.tahun @tahun
json.programs @programs.each do |program|
  json.jenis program[:jenis].titleize
  json.kode program[:kode]
  json.nama program[:nama]
  json.indikator program[:indikators][:indikator]
  json.target program[:indikators][:target]
  json.satuan program[:indikators][:satuan]

  pagu = @subkegiatans
           .select { |prs| prs[:kode_program] == program[:kode] && prs[:kode_sub_opd] == program[:kode_opd] }
           .sum { |sub| sub[:pagu] }
  json.pagu pagu
end
