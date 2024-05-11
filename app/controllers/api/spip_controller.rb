module Api
  class SpipController < ActionController::API
    respond_to :json

    def program
      tahun = params[:tahun]
      kode_opd = params[:kode_opd]
      program_opd = program_opd(kode_opd, tahun)
      opd_x = Opd.find_by(kode_unik_opd: kode_opd)
      @program_kegiatans = [{
        opd: opd_x.nama_opd,
        kode_opd: kode_opd,
        program: program_opd
      }]
    end

    def kegiatan
      tahun = params[:tahun]
      kode_opd = params[:kode_opd]
      kegiatan_opd = kegiatan_opd(kode_opd, tahun)
      opd_x = Opd.find_by(kode_unik_opd: kode_opd)
      @program_kegiatans = [{
        opd: opd_x.nama_opd,
        kode_opd: kode_opd,
        kegiatan: kegiatan_opd
      }]
    end

    def subkegiatan
      tahun = params[:tahun]
      kode_opd = params[:kode_opd]
      subkegiatan_opd = subkegiatan_opd(kode_opd, tahun)
      opd_x = Opd.find_by(kode_unik_opd: kode_opd)
      @program_kegiatans = [{
        opd: opd_x.nama_opd,
        kode_opd: kode_opd,
        subkegiatan: subkegiatan_opd
      }]
    end

    private

    def program_opd(kode_opd, tahun)
      program_kegiatans = ProgramKegiatan.where(kode_sub_skpd: kode_opd)
                                         .where.not(kode_skpd: [nil, ""])
      items = program_kegiatans.map do |pr|
        indikator_programs = indikators(pr.kode_program, 'Program', pr.kode_sub_skpd, tahun)
        pagu_programs = pagu_program(program_kegiatans, kode_opd, tahun, pr.kode_program)

        { jenis: 'program',
          kode_opd: pr.kode_sub_skpd,
          kode: pr.kode_program,
          nama: pr.nama_program,
          pagu: pagu_programs,
          indikator_program: indikator_programs
         }
      end

      item_programs = items.uniq { |pk| pk.values_at(:kode, :kode_opd) }.sort_by { |pk| pk.values_at(:kode) }
      item_programs.map do |prg|
        sasaran_programs = sasaran_program(prg[:kode], tahun)

        { jenis: 'program',
          kode_opd: prg[:kode_opd],
          kode: prg[:kode],
          nama: prg[:nama],
          pagu: prg[:pagu],
          indikator_program: prg[:indikator_program],
          sasaran_program: sasaran_programs
        }
      end
    end

    def kegiatan_opd(kode_opd, tahun)
      program_kegiatans = ProgramKegiatan.where(kode_sub_skpd: kode_opd)
                                         .where.not(kode_skpd: [nil, ""])
      items = program_kegiatans.map do |pr|
        indikator_kegiatans = indikators(pr.kode_giat, 'Kegiatan', pr.kode_sub_skpd, tahun)
        pagu_kegiatans = pagu_kegiatan(program_kegiatans, kode_opd, tahun, pr.kode_giat)

        { jenis: 'kegiatan',
          kode_opd: pr.kode_sub_skpd,
          kode: pr.kode_giat,
          nama: pr.nama_kegiatan,
          pagu: pagu_kegiatans,
          indikator_kegiatan: indikator_kegiatans,
        }
      end

      item_kegiatans = items.uniq { |pk| pk.values_at(:kode, :kode_opd) }.sort_by { |pk| pk.values_at(:kode) }
      item_kegiatans.map do |keg|
        sasaran_kegiatan = sasaran_program(keg[:kode], tahun)

        { jenis: 'kegiatan',
          kode_opd: keg[:kode_opd],
          kode: keg[:kode],
          nama: keg[:nama],
          pagu: keg[:pagu],
          indikator_kegiatan: keg[:indikator_kegiatan],
          sasaran_kegiatan: sasaran_kegiatan
        }
      end
    end

    def subkegiatan_opd(kode_opd, tahun)
      program_kegiatans = ProgramKegiatan.where(kode_sub_skpd: kode_opd)
                                         .where.not(kode_skpd: [nil, ""])
      items = program_kegiatans.map do |pr|
        indikator_subkegiatans = indikators(pr.kode_sub_giat, 'Subkegiatan', pr.kode_sub_skpd, tahun)
        pagu_subkegiatans = pagu_subkegiatan(program_kegiatans, kode_opd, tahun, pr.kode_sub_giat)

        { jenis: 'subkegiatan',
          kode_opd: pr.kode_sub_skpd,
          kode: pr.kode_sub_giat,
          nama: pr.nama_subkegiatan,
          pagu: pagu_subkegiatans,
          indikator_subkegiatan: indikator_subkegiatans }
      end
      item_subkegiatans = items.uniq { |pk| pk.values_at(:kode) }.sort_by { |pk| pk.values_at(:kode) }
      item_subkegiatans.map do |sub|
        sasaran_subkegiatans = sasaran_program(sub[:kode], tahun)
        {
          jenis: 'subkegiatan',
          kode: kode_tweak(sub[:kode]),
          nama: sub[:nama],
          pagu: sub[:pagu],
          indikator_subkegiatan: sub[:indikator_subkegiatan],
          sasaran_subkegiatan: sasaran_subkegiatans
        }
      end
    end

    def indikator_program(kode, jenis, kode_opd, tahun)
      Indikator.where(jenis: "Renstra",
                      sub_jenis: jenis,
                      tahun: tahun,
                      kode: kode,
                      kode_opd: kode_opd)
               .max_by(&:version)
    end

    def pagu_program(program_kegiatans, kode_opd, tahun, kode_program)
      pagu_subkegiatans = program_kegiatans.map do |program_kegiatan|
        indikator = indikator_program(program_kegiatan.kode_sub_giat,
                                      'Subkegiatan', kode_opd, tahun)
        {
          kode_program: program_kegiatan.kode_program,
          pagu_subkegiatan: indikator&.pagu.to_i || 0
        }
      end

      pagu_total = pagu_subkegiatans.group_by { |pagu| pagu[:kode_program] }
                                    .transform_values { |vals| vals.sum { |val| val[:pagu_subkegiatan] } }
      pagu_total[kode_program]
    end

    def pagu_kegiatan(program_kegiatans, kode_opd, tahun, kode_kegiatan)
      pagu_subkegiatans = program_kegiatans.map do |program_kegiatan|
        indikator = indikator_program(program_kegiatan.kode_sub_giat,
                                      'Subkegiatan', kode_opd, tahun)
        {
          kode_kegiatan: program_kegiatan.kode_giat,
          pagu_subkegiatan: indikator&.pagu.to_i || 0
        }
      end

      pagu_total = pagu_subkegiatans.group_by { |pagu| pagu[:kode_kegiatan] }
                                    .transform_values { |vals| vals.sum { |val| val[:pagu_subkegiatan] } }
      pagu_total[kode_kegiatan]
    end

    def pagu_subkegiatan(program_kegiatans, kode_opd, tahun, kode_subkegiatan)
      pagu_subkegiatans = program_kegiatans.map do |program_kegiatan|
        indikator = indikator_program(program_kegiatan.kode_sub_giat,
                                      'Subkegiatan', kode_opd, tahun)
        {
          kode_subkegiatan: program_kegiatan.kode_sub_giat,
          pagu_subkegiatan: indikator&.pagu.to_i || 0
        }
      end

      pagu_total = pagu_subkegiatans.group_by { |pagu| pagu[:kode_subkegiatan] }
                                    .transform_values { |vals| vals.sum { |val| val[:pagu_subkegiatan] } }
      pagu_total[kode_subkegiatan]
    end

    def indikators(kode_program, jenis, kode_opd, tahun)
      indikator = indikator_program(kode_program, jenis, kode_opd, tahun)
      {
        id: indikator&.id,
        tahun: indikator&.tahun,
        indikator: indikator&.indikator,
        target: indikator&.target,
        satuan: indikator&.satuan
      }
    end

    def sasaran_program(program_kegiatan, tahun)
      sasarans = Sasaran.dengan_nip
                        .includes(%i[user program_kegiatan])
                        .joins(:program_kegiatan)
                        .where(tahun: tahun)
                        .where("program_kegiatans.kode_sub_giat ILIKE ?", "%#{program_kegiatan}%")

      sasarans.map do |sasaran|
        {
          id: sasaran.id,
          tahun: sasaran.tahun,
          sasaran: sasaran.sasaran_kinerja,
          nama: sasaran.user.nama,
          nip: sasaran.nip_asn,
          indikator_sasarans: indikator_sasaran(sasaran),
          jabatan: sasaran.user.nama_jabatan_terakhir
        }
      end
    end

    def indikator_sasaran(sasaran)
      indikators = sasaran.indikator_sasarans
      indikators.map do |indikator|
        {
          id: indikator.id,
          indikator: indikator.indikator_kinerja,
          target: indikator.target,
          satuan: indikator.satuan
        }
      end
    end

    def kode_tweak(kode) # khusus subkegiatan
      if kode.scan(/\d+$/).last&.size == 2
        kode.gsub(/[.](?!.*[.])/, ".00\\1")
      else
        kode
      end
    end
  end
end
