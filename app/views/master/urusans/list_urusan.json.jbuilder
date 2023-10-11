json.results @urusans do |urusan|
  json.id urusan.nama_urusan
  json.text "(#{urusan.kode_urusan}) #{urusan.nama_urusan}"
  json.kode urusan.kode_urusan
end
