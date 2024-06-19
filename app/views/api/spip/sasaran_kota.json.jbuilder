json.message 'Sasaran Pemda'
json.tahun @tahun
json.results @sasaran_kota do |sasaran|
  first_child = sasaran.sub_pohons.where(tahun: @tahun).first
  jenis = first_child&.role
  if jenis || sasaran.pohon_khusus
    json.id sasaran.pohonable_id
    json.jenis jenis
    json.sasaran_kota sasaran.pohonable.sasaran_kotum.sasaran
    json.indikators sasaran.pohonable.indikators.each do |indikator|
      json.id indikator.id
      json.id_sasaran indikator.kode
      json.indikator indikator.to_s
      json.target indikator.target
      json.satuan indikator.satuan
    end
  end
end
