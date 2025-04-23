json.results @sasarans do |sasaran|
  subkegiatan_kosong = sasaran.subkegiatan? ? '' : 'text-danger'
  json.id sasaran.id_rencana
  json.text "<span class='#{subkegiatan_kosong}'>#{sasaran.sasaran_kinerja}</span>".html_safe
end
