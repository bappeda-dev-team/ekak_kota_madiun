module Api
  class SpipController < ActionController::API
    respond_to :json

    def opd
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

    private

    def program_opd(kode_opd, tahun)
      program_kegiatans = ProgramKegiatan.where(kode_sub_skpd: kode_opd)
                                         .where.not(kode_skpd: [nil, ""])
      items = program_kegiatans.map do |pr|
        indikator_programs = indikators(pr.kode_program, 'Program', pr.kode_sub_skpd, tahun)
        sasaran_programs = sasaran_program(pr, tahun)
        { jenis: 'program',
          kode_opd: pr.kode_sub_skpd,
          kode: pr.kode_program,
          nama: pr.nama_program,
          pagu: 0,
          indikators: indikator_programs,
          sasaran_program: sasaran_programs }
      end
      items.uniq { |pk| pk.values_at(:kode, :kode_opd) }.sort_by { |pk| pk.values_at(:kode) }
    end

    def indikators(kode_program, jenis, kode_opd, tahun)
      indikator = Indikator.where(jenis: "Renstra",
                                  sub_jenis: jenis,
                                  tahun: tahun,
                                  kode: kode_program,
                                  kode_opd: kode_opd)
                           .max_by(&:version)
      {
        id: indikator&.id,
        tahun: indikator&.tahun,
        indikator: indikator&.indikator,
        target: indikator&.target,
        satuan: indikator&.satuan
      }
    end

    def sasaran_program(program_kegiatan, tahun)
      sasarans = program_kegiatan.sasarans.includes(%i[strategi user])
                                 .where(tahun: tahun).dengan_strategi
      sasarans.map do |sasaran|
        {
          id: sasaran.id,
          sasaran: sasaran.sasaran_kinerja,
          nama: sasaran.user.nama,
          nip: sasaran.nip_asn,
          indikator_sasarans: indikator_sasaran(sasaran),
          strategi: sasaran.strategi.to_s,
          role: sasaran.strategi.role,
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
  end
end
