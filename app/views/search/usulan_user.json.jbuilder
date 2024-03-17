json.results @results do |res|
  json.id res.id
  json.text res.usulan_tahun
  json.usulan_type res.class.name
end
