json.results @rekenings do |rekening|
  json.id rekening.id
  json.text rekening.kode_rekening + " - " + rekening.jenis_rekening
end
