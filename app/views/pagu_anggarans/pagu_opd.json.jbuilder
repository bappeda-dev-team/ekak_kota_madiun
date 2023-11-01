json.message "Pagu OPD"
json.data do
  @anggaran_opd.each do |opd, pagu|
    json.kode_opd opd[:kode_opd]
    json.nama_opd opd[:nama_opd]
    json.pagu_sipd pagu
  end
end
