json.message "Sasaran OPD"
json.data do
  json.tahun @tahun
  json.kode_opd @opd.kode_unik_opd
  json.opd @opd.nama_opd
  json.kepala_opd @kepala_opd.nama
  json.nip_kepala_opd @kepala_opd.nik
  json.jumlah_sasaran @sasaran_opds.size
  json.sasaran_opds @sasaran_opds do |sasaran_opd|
    json.id_sasaran sasaran_opd.id
    json.sasaran_opd sasaran_opd.sasaran_kinerja
    json.tahun sasaran_opd.tahun
    json.indikator_sasaran sasaran_opd.indikator_sasarans do |indikator|
      json.aspek indikator.aspek
      json.indikator indikator.indikator_kinerja
      json.target indikator.target
      json.satuan indikator.satuan
    end
  end
end
