json.results @results do |res|
  json.id res.id
  json.text res.usulan_tahun
  json.usulan_type res.class.name
  json.decorate res.respond_to?(:opd_lead) ? res.nama_opd_lead : nil
end
