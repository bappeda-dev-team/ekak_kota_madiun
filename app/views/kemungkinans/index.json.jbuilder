json.results @kemungkinans.each do |kemungkinan|
  json.id kemungkinan.id
  json.text "#{kemungkinan.nilai} #{kemungkinan.deskripsi}"
end
