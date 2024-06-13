json.results do
  json.tahun @tahun
  json.id @pohon_sub.id
  json.kode_sasaran_pemda @sasaran_pemda.id
  json.sasaran_pemda @sasaran_pemda.to_s
  json.indikator_sasaran_pemda @sasaran_pemda.indikators.each do |indikator|
    json.id indikator.id
    json.id_sasaran indikator.kode.to_i
    json.indikator indikator.to_s
    json.target indikator.target
    json.satuan indikator.satuan
  end
  results = @rad_sasaran_kota
  json.sasaran_opds results do |sasaran|
    sas = SasaranKota::SasaranComponent.new(sasaran: sasaran, sasaran_iteration: [], tahun: @tahun)
    json.id sasaran.id
    json.parent_sasaran sasaran.pohon_ref_id
    json.opd sas.opd
    json.jenis sas.jenis
    json.sasaran_opd sas.renaksi
    json.indikators sas.indikators.each do |indikator|
      json.id indikator.id
      json.id_sasaran indikator.kode.to_i
      json.jenis indikator.jenis
      json.indikator indikator.to_s
      json.target indikator.target
      json.satuan indikator.satuan
    end
    json.sasaran_programs sas.sub_pohons.each do |tactical|
      sas_tac = SasaranKota::SasaranComponent.new(sasaran: tactical, sasaran_iteration: [], tahun: @tahun)
      json.id tactical.id
      json.parent_sasaran tactical.pohon_ref_id
      json.opd sas_tac.opd
      json.jenis sas_tac.jenis
      json.programs sas_tac.programs.uniq(&:kode_program).each do |program|
        json.id_program program.id
        json.kode_program program.kode_program
        json.nama_program program.nama_program
      end
      json.sasaran_program sas_tac.renaksi
      json.indikator_sasaran_program sas_tac.indikators.each do |indikator|
        json.indikator indikator.to_s
        json.target indikator.target
        json.satuan indikator.satuan
      end
      json.sasaran_kegiatans sas_tac.sub_pohons.each do |operational|
        sas_op = SasaranKota::SasaranComponent.new(sasaran: operational, sasaran_iteration: [], tahun: @tahun)
        keg = sas_op.subkegiatans
        json.id operational.id_rencana
        json.parent_sasaran tactical.id
        json.opd sas_op.opd
        json.jenis sas_op.jenis
        if keg.present?
          json.id_kegiatan keg.id
          json.kode_kegiatan keg.kode_giat
          json.nama_kegiatan keg.nama_kegiatan
        end
        json.sasaran_kegiatan sas_op.renaksi
        json.indikator_sasaran_kegiatan sas_op.indikators.each do |indikator|
          json.id indikator.id
          json.id_sasaran indikator.sasaran_id
          json.indikator indikator.to_s
          json.target indikator.target
          json.satuan indikator.satuan
        end
        if keg.present?
          json.kode_subkegiatan keg.kode_sub_giat
          json.nama_subkegiatan keg.nama_subkegiatan
          json.sasaran_subkegiatan sas_op.renaksi
          json.indikator_sasaran_subkegiatan sas_op.indikators.each do |indikator|
            json.id indikator.id
            json.id_sasaran indikator.sasaran_id
            json.indikator indikator.to_s
            json.target indikator.target
            json.satuan indikator.satuan
          end
        end
      end
    end
  end
end
