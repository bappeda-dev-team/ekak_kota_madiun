json.results @programKegiatans do |program|
  json.id program.id
  json.text "#{program.nama_opd_pemilik} | #{program.nama_subkegiatan} | #{program.tahun}"
end
