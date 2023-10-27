json.message "Data Program Tematik - KAK"
json.data do
  json.tematik @tematik.tema
  json.tahun @tahun
  json.jumlah_pagu @jumlah
  json.opd @opds do |opd, programs|
    json.kode_opd opd[0]
    json.nama_opd opd[1]
    json.pagu_total programs.values.sum
    json.programs programs do |program, pagu|
      json.kode_program program[0]
      json.nama_program program[1]
      json.pagu pagu
    end
  end
end
