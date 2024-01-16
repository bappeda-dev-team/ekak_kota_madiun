json.results @mandatoris do |mandatori|
  json.id mandatori.id
  json.text mandatori.usulan_tahun
  json.usulan_type mandatori.class.name
end
