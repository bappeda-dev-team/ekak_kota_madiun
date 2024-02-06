json.message "Tujuan OPD"
json.data do
  json.kode_opd @opd.kode_unik_opd
  json.opd @opd.nama_opd
  json.jumlah_tujuan @tujuan_opds.size
  json.tujuan_opds @tujuan_opds do |tujuan_opd|
    json.id_tujuan tujuan_opd.id

    json.id_urusan tujuan_opd.urusan&.id
    json.kode_urusan tujuan_opd.urusan&.kode_urusan
    json.urusan tujuan_opd.urusan&.nama_urusan

    json.id_bidang_urusan tujuan_opd.bidang_urusan&.id
    json.kode_bidang_urusan tujuan_opd.bidang_urusan&.kode_bidang_urusan
    json.bidang_urusan tujuan_opd.bidang_urusan&.nama_bidang_urusan

    json.tujuan_opd tujuan_opd.tujuan
    json.tahun_awal tujuan_opd.tahun_awal
    json.tahun_akhir tujuan_opd.tahun_akhir
    json.indikator_tujuan tujuan_opd.indikators do |indikator|
      json.indikator indikator.indikator
      json.target_tujuan @range do |tahun|
        target = indikator.targets.find_by(tahun: tahun)
        json.tahun tahun
        json.target target&.target
        json.satuan target&.satuan
      end
    end
  end
end
