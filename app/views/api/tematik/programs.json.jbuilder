json.message "Data Program Tematik - KAK"
json.data do
  json.tematik @tematik.tema
  json.tahun @tahun
  json.jumlah_programs @programs.size
  json.jumlah_pagu @jumlah
  json.programs @programs do |program, pagu|
    json.kode_program program[0]
    json.nama_program program[1]
    json.pagu pagu
  end
end
