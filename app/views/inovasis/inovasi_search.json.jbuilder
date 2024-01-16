json.results @inovasis do |inovasi|
  json.id inovasi.id
  json.text inovasi.usulan_tahun
  json.usulan_type inovasi.class.name
end
