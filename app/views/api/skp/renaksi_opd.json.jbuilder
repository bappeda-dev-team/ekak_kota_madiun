json.message "Data Renaksi OPD #{@opd} - KAK"
json.data do
  json.tahun @tahun
  json.kode_opd @kode_opd
  json.opd @opd.nama_opd
  json.sasaran_opds @sasaran_opds do |sasaran|
    json.id_sasaran_opd sasaran.id_rencana
    json.sasaran_opd sasaran.sasaran_kinerja
    json.indikator_sasaran_opd sasaran.indikator_sasarans do |indikator_sasaran|
      json.id_indikator indikator_sasaran.id
      json.id_sasaran indikator_sasaran.sasaran_id
      json.indikator indikator_sasaran.indikator_kinerja
      json.target indikator_sasaran.target
      json.satuan indikator_sasaran.satuan
    end
    json.renaksi_opds sasaran.rencana_aksi_opds do |renaksi_opd|
      json.id renaksi_opd.id_rencana_renaksi
      json.id_sasaran_opd renaksi_opd.sasaran_id
      json.aksi renaksi_opd.to_s
      json.is_perintah_walikota renaksi_opd.perintah_walikota?
      json.terdapat_inovasi renaksi_opd.inovasi?
      json.is_sasaran_prioritas renaksi_opd.program_unggulan?
      json.nama_pemilik renaksi_opd.nama_pemilik_saja
      json.nip_pemilik renaksi_opd.nip_pemilik_saja
      json.anggaran renaksi_opd&.anggaran_renaksi
      json.subkegiatan renaksi_opd.subkegiatan_renaksi&.nama_subkegiatan
      json.kode_subkegiatan renaksi_opd.subkegiatan_renaksi&.kode_sub_fix_sipd
      json.keterangan renaksi_opd.keterangan
      json.jadwal_pelaksanaan do
        json.tw1 renaksi_opd.tw1
        json.tw2 renaksi_opd.tw2
        json.tw3 renaksi_opd.tw3
        json.tw4 renaksi_opd.tw4
      end
    end
  end
end
