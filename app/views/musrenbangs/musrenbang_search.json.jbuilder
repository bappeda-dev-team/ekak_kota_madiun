json.results @musrenbangs do |musrenbang|
  json.id musrenbang.id
  json.text musrenbang.usulan_tahun
  json.usulan_type musrenbang.class.name
end
