json.message "Rankir Renja - KAK"
json.data do
  renjas = TabelRenjaComponent.new(program_kegiatans: @program_kegiatans)
  json.renja renjas.sub_opd.each do |opd|
    renja = RenjaComponent.new(program: opd, anggaran: renjas.pagu_sub_opd(opd[:kode]))
    json.jenis renja.title
    json.kode renja.kode_tweak
    json.nama renja.nama
    if renja.with_indikator?
      json.indikator renja.indikators[:indikator]
      json.target renja.indikators[:target]
      json.satuan renja.indikators[:satuan]
    end
    json.pagu renja.pagu
    # urusan
    json.urusans renjas.urusan_opd.each do |urusan|
      renja = RenjaComponent.new(program: urusan,
                                 anggaran: renjas.pagu_urusan(urusan[:kode], opd[:kode]))
      json.jenis renja.title
      json.kode renja.kode_tweak
      json.nama renja.nama
      if renja.with_indikator?
        json.indikator renja.indikators[:indikator]
        json.target renja.indikators[:target]
        json.satuan renja.indikators[:satuan]
      end
      json.pagu renja.pagu
      # bidang urusan
      json.bidang_urusans renjas.bidang_urusan_opd(urusan[:kode]).each do |bidang_urusan|
        renja = RenjaComponent.new(program: bidang_urusan,
                                   anggaran: renjas.pagu_bidang_urusan(bidang_urusan[:kode], opd[:kode]))
        json.jenis renja.title
        json.kode renja.kode_tweak
        json.nama renja.nama
        if renja.with_indikator?
          json.indikator renja.indikators[:indikator]
          json.target renja.indikators[:target]
          json.satuan renja.indikators[:satuan]
        end
        json.pagu renja.pagu
        # program
        json.programs renjas.program_opd(bidang_urusan[:kode], opd[:kode]).each do |program|
          renja = RenjaComponent.new(program: program,
                                     anggaran: renjas.pagu_program(program[:kode], opd[:kode]))
          json.jenis renja.title
          json.kode renja.kode_tweak
          json.nama renja.nama
          if renja.with_indikator?
            json.indikator renja.indikators[:indikator]
            json.target renja.indikators[:target]
            json.satuan renja.indikators[:satuan]
          end
          json.pagu renja.pagu
          # kegiatan
          json.kegiatans renjas.kegiatan_opd(program[:kode], opd[:kode]).each do |kegiatan|
            renja = RenjaComponent.new(program: kegiatan,
                                       anggaran: renjas.pagu_kegiatan(kegiatan[:kode], opd[:kode]))
            json.jenis renja.title
            json.kode renja.kode_tweak
            json.nama renja.nama
            if renja.with_indikator?
              json.indikator renja.indikators[:indikator]
              json.target renja.indikators[:target]
              json.satuan renja.indikators[:satuan]
            end
            json.pagu renja.pagu
            # subkegiatan
            json.subkegiatans renjas.subkegiatan_opd(kegiatan[:kode], opd[:kode]).each do |subkegiatan|
              renja = RenjaComponent.new(program: subkegiatan)
              json.jenis renja.title
              json.kode renja.kode_tweak
              json.nama renja.nama
              if renja.with_indikator?
                json.indikator renja.indikators[:indikator]
                json.target renja.indikators[:target]
                json.satuan renja.indikators[:satuan]
              end
              json.pagu renja.pagu
            end
          end
        end
      end
    end
  end
end
