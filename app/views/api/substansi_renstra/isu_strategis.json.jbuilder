json.message 'Isu Strategis'
json.tahun @tahun
json.kode_opd @kode_opd
json.nama_opd @opd.nama_opd
json.isu_strategis_opds @isu_strategis.each do |isu|
  json.isu_strategis isu.isu_strategis
  json.data_dukungs isu.permasalahan_opds.each do |masalah|
    masalah.data_dukungs.each do |data_dukung|
      json.data_dukung data_dukung.nama_data
      json.uraian_narasi data_dukung.keterangan
    end
  end
end
