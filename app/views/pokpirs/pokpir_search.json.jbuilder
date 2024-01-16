json.results @pokpirs do |pokpir|
  json.id pokpir.id
  json.text pokpir.usulan_tahun
  json.usulan_type pokpir.class.name
end
