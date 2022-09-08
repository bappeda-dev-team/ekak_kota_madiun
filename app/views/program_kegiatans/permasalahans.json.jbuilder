json.results @program_kegiatans do |kode, programs|
    json.kode_program kode
    json.details programs do |program|
      json.program program[:nama_program]
      json.indikator_program program[:indikator]
      json.target_program program[:target]
      json.satuan_program program[:satuan]
      json.subkegiatan program[:subkegiatan]
      json.indikator_sub program[:indikator_sub]
      json.target_sub program[:target_sub]
      json.satuan_sub program[:satuan_sub]
      json.isu_strategis program[:isu_strategis]
      json.permasalahans program[:permasalahans] 
  end
end
