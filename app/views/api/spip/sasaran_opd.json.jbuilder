json.results do
  json.tahun @tahun
  json.opd @opd.nama_opd
  json.sasaran_opds @sasaran_opd_spip[:strategic] do |sasaran|
    json.id_sasaran sasaran.id
    json.id_strategi_atasan sasaran.strategi.strategi_ref_id.to_i
    json.strategi_id sasaran.strategi.id
    json.kode_sasaran sasaran.id_rencana
    json.sasaran_opd sasaran.sasaran_kinerja
    json.indikators sasaran.indikator_sasarans.each do |indikator|
      json.id_indikator indikator.id
      json.kode_indikator indikator.sasaran_id
      json.indikator indikator.indikator_kinerja
      json.target indikator.target
      json.satuan indikator.satuan
    end
    json.sasaran_programs @sasaran_opd_spip[:tactical].select { |sas| sas.strategi.strategi_ref_id.to_i == sasaran.strategi.id } do |tactical|
      operationals = @sasaran_opd_spip[:operational].select { |sas| sas.strategi.strategi_ref_id.to_i == tactical.strategi.id }
      json.id_sasaran tactical.id
      json.id_strategi_atasan tactical.strategi.strategi_ref_id.to_i
      json.strategi_id tactical.strategi.id
      json.kode_sasaran tactical.id_rencana
      json.programs operationals.map { |oo| oo.program_sasaran }.uniq
      json.sasaran_program tactical.sasaran_kinerja
      json.indikators tactical.indikator_sasarans.each do |indikator|
        json.id_indikator indikator.id
        json.kode_indikator indikator.sasaran_id
        json.indikator indikator.indikator_kinerja
        json.target indikator.target
        json.satuan indikator.satuan
      end
      json.sasaran_subkegiatans operationals do |operational|
        json.id_sasaran operational.id
        json.id_strategi_atasan operational.strategi.strategi_ref_id.to_i
        json.strategi_id operational.strategi.id
        json.kode_sasaran operational.id_rencana
        json.kegiatan operational.kegiatan_sasaran
        json.sub_kegiatan operational.subkegiatan_sasaran
        json.sasaran_subkegiatan operational.sasaran_kinerja
        json.indikators operational.indikator_sasarans.each do |indikator|
          json.id_indikator indikator.id
          json.kode_indikator indikator.sasaran_id
          json.indikator indikator.indikator_kinerja
          json.target indikator.target
          json.satuan indikator.satuan
        end
      end
    end
  end
end
