json.results @rekenings do |rekening|
  json.id rekening.kode_rekening
  json.text "#{rekening.kode_rekening} - #{rekening.jenis_rekening}"
end
