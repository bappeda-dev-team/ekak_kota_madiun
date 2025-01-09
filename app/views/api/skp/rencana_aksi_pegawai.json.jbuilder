json.message "Data Rencana Aksi Sasaran Kinerja ASN - KAK"
if @status_rencana_aksi
  json.data do
    json.status_rencana_aksi @status_rencana_aksi
    json.eselon @eselon
    json.nama_asn @user.nama
    json.nip @nip
    json.tahun @tahun
    json.kode_opd @user.opd.kode_unik_opd
    json.opd @user.opd.nama_opd
    json.id_sasaran @id_sasaran
    json.message "Renaksi Tidak Ditemukan"
  end
else
  json.data do
    json.status_rencana_aksi @status_rencana_aksi
    json.eselon @eselon
    json.nama_asn @user.nama
    json.nip @nip
    json.tahun @tahun
    json.kode_opd @user.opd.kode_unik_opd
    json.opd @user.opd.nama_opd
    json.id_sasaran @sasaran.id_rencana
    json.sasaran @sasaran.sasaran_kinerja
    json.anggaran @sasaran.total_anggaran
    json.rencana_aksi @tahapans do |renaksi|
      json.id_renaksi renaksi.id
      json.id_tahapan renaksi.id_rencana_aksi
      json.id_sasaran renaksi.id_rencana
      json.urutan renaksi&.urutan
      json.tahapan_kerja renaksi.tahapan_kerja
      json.sebagai_rtp renaksi.rtp_mr?
      json.tahapan_rtp renaksi.tahapan_with_rtp_tag
      json.anggaran_tahapan renaksi.anggaran_tahapan
      json.created_at renaksi.created_at
      json.aksis renaksi.aksis do |aksi|
        json.id_aksi aksi.id
        json.id_tahapan aksi.id_rencana_aksi
        json.bulan aksi.bulan
        json.target aksi.target
      end
    end
  end
end
