json.results @pohon_tematiks do |pohon|
  json.id pohon.id
  json.text pohon.pohonable.to_s
end
