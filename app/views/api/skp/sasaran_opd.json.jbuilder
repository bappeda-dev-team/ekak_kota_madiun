json.message "Sasaran OPD - KAK"
json.data do
  json.tahun @tahun
  json.kode_opd @opd.kode_unik_opd
  json.opd @opd.nama_opd
  json.kepala_opd @kepala_opd.nama
  json.nip_kepala_opd @kepala_opd.nik
  json.jumlah_sasaran_valid @sasaran_opds.size
  json.sasaran_opds @sasaran_opds do |sasaran_opd|
    json.id_sasaran sasaran_opd.id

    json.strategi_kota_id sasaran_opd.strategi.strategi_asli.pohon.parent_pohon.pohonable_id
    json.strategi_kota sasaran_opd.strategi.strategi_asli.pohon.parent_pohon.pohonable.to_s
    json.sasaran_kota sasaran_opd.strategi.strategi_asli.pohon.parent_pohon.pohonable&.sasaran_kotum.to_s

    json.strategi_opd sasaran_opd.strategi.to_s
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
