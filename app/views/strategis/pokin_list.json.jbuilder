json.results @pohons do |pohon|
  json.id pohon.pohonable_id
  json.text "#{pohon.nama_strategi} - #{pohon.tahun}"
end
