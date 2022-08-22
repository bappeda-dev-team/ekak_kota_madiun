json.results @skalas.each do |skala|
  json.id skala.id
  json.text "#{skala.nilai} - #{skala.deskripsi}"
end
