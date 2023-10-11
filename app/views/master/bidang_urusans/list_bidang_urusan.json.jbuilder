json.results @bidang_urusans do |bidang_urusan|
  json.id bidang_urusan.nama_bidang_urusan
  json.text "#{bidang_urusan.kode_bidang_urusan} #{bidang_urusan.nama_bidang_urusan}"
  json.kode bidang_urusan.kode_bidang_urusan
end
