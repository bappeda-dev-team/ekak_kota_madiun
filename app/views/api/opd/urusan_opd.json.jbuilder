json.results @opds do |opd|
  json.kode_opd opd.kode_unik_opd
  json.nama_opd opd.nama_opd
  json.urusan_opd opd.list_urusans do |urusan|
    json.kode_urusan urusan[0]
    json.urusan urusan[1]
    json.bidang_urusan_opd(opd.list_bidang_urusans.select { |kode, _| kode.first == urusan[0] }) do |bidang|
      json.kode_bidang_urusan bidang[0]
      json.bidang_urusan bidang[1]
    end
  end
end
