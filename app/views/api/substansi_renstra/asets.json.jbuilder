json.message 'Aset OPD'
json.tahun @tahun
json.kode_opd @kode_opd
json.nama_opd @opd.nama_opd
json.asets @asets.each do |aset|
  json.aset aset.nama_aset
  json.jumlah_aset aset.jumlah
  json.satuan_aset aset.satuan
  json.kondisi aset.status_aset
  json.tahun_perolehan_aset aset.tahun_perolehan_aset
  json.keterangan aset.keterangan
end
