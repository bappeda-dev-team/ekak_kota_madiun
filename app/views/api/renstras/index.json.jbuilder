json.message "Renstra - KAK"
json.data do
  json.periode "#{@tahun_awal}-#{@tahun_akhir}"
  json.kode_opd @kode_opd
  json.nama_opd @nama_opd
  json.pagu_opd @periode do |tahun_opd|
    pagu_opd = Indikator.where(jenis: 'Renstra',
                               sub_jenis: 'Subkegiatan',
                               kode_opd: @opd.kode_unik_opd,
                               tahun: tahun_opd)
                        .group_by(&:kode)
                        .map { |_k, v| v.max_by(&:version) }
                        .inject(0) { |inj, pagu| inj + pagu.pagu.to_i }
    realisasi_pagu_opd = Indikator.where(jenis: 'Renstra',
                                         sub_jenis: 'Subkegiatan',
                                         kode_opd: @opd.kode_unik_opd,
                                         tahun: tahun_opd)
                                  .group_by(&:kode)
                                  .map { |_k, v| v.max_by(&:version) }
                                  .inject(0) { |inj, pagu| inj + pagu.realisasi_pagu.to_i }

    json.tahun tahun_opd
    json.total_pagu_opd pagu_opd
    json.total_pagu_realisasi_opd realisasi_pagu_opd
  end
  json.renstra_opd @program_kegiatans do |urusan, bid_urusans|
    json.kode_urusan urusan[0]
    json.nama_urusan urusan[1]
    json.pagu_urusan @periode do |tahun_urusan|
      pagu_urusan = Indikator.where(jenis: 'Renstra',
                                    sub_jenis: 'Subkegiatan',
                                    kode_opd: @opd.kode_unik_opd,
                                    tahun: tahun_urusan)
                             .filter { |hh| hh.kode_urusan == urusan[0] }
                             .group_by(&:kode)
                             .map { |_k, v| v.max_by(&:version) }
                             .inject(0) { |inj, pagu| inj + pagu.pagu.to_i }
      realisasi_pagu_urusan = Indikator.where(jenis: 'Renstra',
                                              sub_jenis: 'Subkegiatan',
                                              kode_opd: @opd.kode_unik_opd,
                                              tahun: tahun_urusan)
                                       .filter { |hh| hh.kode_urusan == urusan[0] }
                                       .group_by(&:kode)
                                       .map { |_k, v| v.max_by(&:version) }
                                       .inject(0) { |inj, pagu| inj + pagu.realisasi_pagu.to_i }

      json.total_pagu_urusan pagu_urusan
      json.total_pagu_realisasi_urusan realisasi_pagu_urusan
    end
    json.bidang_urusan_opd bid_urusans do |bid_urusan, programs|
      json.kode_bidang_urusan bid_urusan[0]
      json.nama_bidang_urusan bid_urusan[1]
      json.pagu_bidang_urusan @periode do |tahun_bid|
        pagu_bid_urusan = Indikator.where(jenis: 'Renstra',
                                          sub_jenis: 'Subkegiatan',
                                          kode_opd: @opd.kode_unik_opd,
                                          tahun: tahun_bid)
                                   .filter { |hh| hh.kode_bidang_urusan == bid_urusan[0] }
                                   .group_by(&:kode)
                                   .map { |_k, v| v.max_by(&:version) }
                                   .inject(0) { |inj, pagu| inj + pagu.pagu.to_i }
        realisasi_pagu_bid_urusan = Indikator.where(jenis: 'Renstra',
                                                    sub_jenis: 'Subkegiatan',
                                                    kode_opd: @opd.kode_unik_opd,
                                                    tahun: tahun_bid)
                                             .filter { |hh| hh.kode_bidang_urusan == bid_urusan[0] }
                                             .group_by(&:kode)
                                             .map { |_k, v| v.max_by(&:version) }
                                             .inject(0) { |inj, pagu| inj + pagu.realisasi_pagu.to_i }

        json.total_pagu_bidang_urusan pagu_bid_urusan
        json.total_pagu_realisasi_bidang_urusan realisasi_pagu_bid_urusan
      end
      json.program_opd programs do |program|
        json.kode_program program.kode_program
        json.nama_program program.nama_program
        indikator_programs = program.indikator_renstras_new('program',
                                                            @kode_opd)[:indikator_program].sort_by(&:tahun)
        json.indikator_program @periode do |tahun|
          json.partial! partial: 'api/renstras/indikator_renstra',
                        locals: { tahun: tahun, indikators: indikator_programs }
        end
        json.kegiatan_opd program.kegiatans_opd do |kegiatan|
          json.kode_kegiatan kegiatan.kode_giat
          json.nama_kegiatan kegiatan.nama_kegiatan
          indikator_kegiatans = kegiatan.indikator_renstras_new('kegiatan',
                                                                @kode_opd)[:indikator_kegiatan].sort_by(&:tahun)
          json.indikator_kegiatan @periode do |tahun_keg|
            json.partial! partial: 'api/renstras/indikator_renstra',
                          locals: { tahun: tahun_keg, indikators: indikator_kegiatans }
          end
          json.subkegiatan_opd kegiatan.subkegiatans_opd do |subkegiatan|
            json.kode_subkegiatan subkegiatan.kode_sub_giat
            json.nama_subkegiatan subkegiatan.nama_subkegiatan
            indikator_subkegiatans = subkegiatan.indikator_renstras_new('subkegiatan',
                                                                        @kode_opd)[:indikator_subkegiatan].sort_by(&:tahun)
            json.indikator_subkegiatan @periode do |tahun_subkeg|
              json.partial! partial: 'api/renstras/indikator_renstra',
                            locals: { tahun: tahun_subkeg, indikators: indikator_subkegiatans }
            end
          end
        end
      end
    end
  end
end
