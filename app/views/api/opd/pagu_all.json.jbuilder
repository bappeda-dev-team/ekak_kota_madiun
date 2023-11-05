json.message "Pagu OPD"
json.data @results do |res|
  json.kode_opd res[:kode_opd]
  json.nama_opd res[:nama_opd]
  json.pagu_kak res[:pagu_kak]
  json.pagu_sipd res[:pagu_sipd]
end
