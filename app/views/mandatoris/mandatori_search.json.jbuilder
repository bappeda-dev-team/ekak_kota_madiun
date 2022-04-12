json.results @mandatoris do |mandatori|
  json.id mandatori.id
  json.text mandatori.usulan
  json.usulan_type mandatori.class.name
end
