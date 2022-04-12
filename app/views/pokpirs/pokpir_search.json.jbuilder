json.results @pokpirs do |pokpir|
  json.id pokpir.id
  json.text pokpir.usulan
  json.usulan_type pokpir.class.name
end
