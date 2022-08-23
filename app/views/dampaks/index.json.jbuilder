json.results @dampaks.each do |dampak|
  json.id dampak.id
  json.text "#{dampak.nilai} #{dampak.deskripsi}"
end
