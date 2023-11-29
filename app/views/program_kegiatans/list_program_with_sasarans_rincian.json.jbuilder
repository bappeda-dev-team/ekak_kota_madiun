json.results @program_kegiatans do |program|
  json.id program.id
  json.text "#{program.nama_opd_pemilik} | #{program.nama_subkegiatan}"
end
