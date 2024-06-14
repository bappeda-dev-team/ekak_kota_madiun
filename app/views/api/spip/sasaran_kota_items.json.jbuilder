json.results do
  json.sasaran_pemda_id @sasaran_pemda.id
  json.tahun @tahun
  json.id @pohon_sub.id
  json.sasaran_pemda @sasaran_pemda.sasaran_kotum.sasaran
  json.indikator_sasaran_pemda @sasaran_pemda.indikators.each do |indikator|
    json.id indikator.id
    json.id_sasaran @pohon_sub.id
    json.indikator indikator.to_s
    json.target indikator.target
    json.satuan indikator.satuan
  end
  results = @rad_sasaran_kota
  json.sasaran_opds results do |sasaran_opd|
    sas = SasaranKota::SasaranComponent.new(sasaran: sasaran_opd, sasaran_iteration: [], tahun: @tahun)
    json.id sasaran_opd.id
    json.parent_sasaran sasaran_opd.pohon_ref_id
    json.jenis sas.jenis
    json.nama_opd sas.opd
    json.kode_opd sasaran_opd.opd.kode_unik_opd
    json.sasaran_opd sas.renaksi
    json.indikators sas.indikators.each do |indikator|
      json.id indikator.id
      json.id_sasaran sasaran_opd.id
      json.indikator indikator.to_s
      json.target indikator.target
      json.satuan indikator.satuan
    end
    json.programs sas.sub_pohons.each do |tactical|
      sas_tac = SasaranKota::SasaranComponent.new(sasaran: tactical, sasaran_iteration: [], tahun: @tahun)
      sas_tac.programs.uniq(&:kode_program).each do |program|
        json.id_program program.id
        json.kode_program program.kode_program
        json.nama_program program.nama_program
        json.id tactical.id
        json.parent_sasaran tactical.pohon_ref_id
        json.jenis sas_tac.jenis
        json.nama_opd sas_tac.opd
        json.kode_opd tactical.opd.kode_unik_opd
        json.sasaran_program sas_tac.renaksi
        json.indikator_sasaran_program sas_tac.indikators.each do |indikator|
          json.id indikator.id
          json.id_sasaran tactical.id
          json.indikator indikator.to_s
          json.target indikator.target
          json.satuan indikator.satuan
        end
        json.kegiatans tactical.sub_pohons.select(&:pohonable).each do |operational|
          kegs = operational.pohonable.sasarans.dengan_nip.dengan_sub_kegiatan
                   .flat_map { |sas| sas.program_kegiatan }
                   .uniq { |pr| pr.kode_giat }
          kegs.each do |keg|
            json.id_kegiatan keg.id
            json.kode_kegiatan keg.kode_giat
            json.nama_kegiatan keg.nama_kegiatan
            json.id operational.id
            json.parent_sasaran operational.pohon_ref_id
            json.jenis 'sasaran_kegiatan'
            json.nama_opd operational.opd.nama_opd
            json.kode_opd operational.opd.kode_unik_opd
            json.sasaran_kegiatan operational.pohonable.strategi
            json.indikator_sasaran_kegiatan operational.pohonable.indikators.each do |indikator|
              json.id indikator.id
              json.id_sasaran operational.id
              json.indikator indikator.to_s
              json.target indikator.target
              json.satuan indikator.satuan
            end
            sasarans = operational.pohonable.sasarans.dengan_nip.dengan_sub_kegiatan
            json.subkegiatans sasarans.each do |sasaran|
              subkegiatan = sasaran.program_kegiatan
              json.id_subkegiatan subkegiatan.id
              json.kode_subkegiatan subkegiatan.kode_sub_giat
              json.nama_subkegiatan subkegiatan.nama_subkegiatan
              json.id sasaran.id_rencana
              json.parent_sasaran operational.id
              json.jenis 'sasaran_subkegiatan'
              json.nama_opd sasaran.opd.nama_opd
              json.kode_opd sasaran.opd.kode_unik_opd
              json.sasaran_subkegiatan sasaran.sasaran_kinerja
              json.indikator_sasaran_subkegiatan sasaran.indikator_sasarans.each do |indikator|
                json.id indikator.id
                json.id_sasaran indikator.sasaran_id
                json.indikator indikator.indikator_kinerja
                json.target indikator.target
                json.satuan indikator.satuan
              end
            end
          end
        end
      end
    end
  end
end
