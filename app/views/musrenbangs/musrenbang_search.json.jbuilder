json.results @musrenbangs do |musrenbang|
  json.id musrenbang.id
  json.text musrenbang.usulan
  json.usulan_type musrenbang.class.name
end
