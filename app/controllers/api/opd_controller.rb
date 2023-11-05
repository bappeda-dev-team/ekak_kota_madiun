module Api
  class OpdController < ActionController::API
    respond_to :json

    def daftar_opd
      @opds = Opd.where.not(kode_unik_opd: nil)
    end

    def find_opd
      nama_opd = params[:q]
      @opds = Opd.where('nama_opd ILIKE ?', "%#{nama_opd}%")
      render 'daftar_opd'
    end

    def with_bidang
      @opds = Opd.where(has_bidang: true)
    end

    def urusan_opd
      @opds = Opd.where.not(kode_unik_opd: nil)
                 .where.not(urusan: [nil, ''])
    end

    def tujuan_opd
      @opd = Opd.find_by!(kode_unik_opd: params[:kode_opd])
      @tujuan_opds = @opd.tujuan_opds.includes(%i[indikators])
    rescue ActiveRecord::RecordNotFound
      @error = "Opd tidak ditemukan"
      render json: { message: "terjadi kesalahan", errors: @error }.to_json,
             status: :not_found
    end

    def perbandingan_pagu # rubocop:disable Metrics
      tahun = params[:tahun]
      kode_opd = params[:kode_opd]
      opd = Opd.find_by(kode_unik_opd: kode_opd)
      @nama_opd = opd.nama_opd
      @kode_opd = kode_opd

      subkegiatan_opd = opd.program_kegiatans.subkegiatans_satunya

      @anggaran_subkegiatans = subkegiatan_opd.order(:kode_sub_giat).map do |sub|
        anggaran_kak = PaguAnggaran.find_by(kode_opd: kode_opd,
                                            kode: sub.kode_sub_giat,
                                            tahun: tahun,
                                            jenis: 'Perencanaan',
                                            sub_jenis: 'SubKegiatan')
        pagu_kak = anggaran_kak&.anggaran.to_i || 0
        anggaran_sipd = PaguAnggaran.find_by(kode_opd: kode_opd,
                                             kode: sub.kode_sub_giat,
                                             tahun: tahun,
                                             jenis: 'Penetapan',
                                             sub_jenis: 'SubKegiatan')
        pagu_sipd = anggaran_sipd&.anggaran.to_i || 0
        {
          nama_subkegiatan: sub.nama_subkegiatan,
          kode_subkegiatan: sub.kode_sub_giat,
          pagu_subkegiatan_kak: pagu_kak,
          pagu_subkegiatan_sipd: pagu_sipd
        }
      end
    end

    def pagu_all # rubocop:disable Metrics/MethodLength
      tahun = params[:tahun]
      opds = Opd.with_user
      @results = opds.map do |opd|
        anggaran_kak = PaguAnggaran.where(kode_opd: opd.kode_unik_opd,
                                          tahun: tahun,
                                          jenis: 'Perencanaan',
                                          sub_jenis: 'SubKegiatan')
                                   .sum(:anggaran).to_i
        anggaran_sipd = PaguAnggaran.where(kode_opd: opd.kode_unik_opd,
                                           tahun: tahun,
                                           jenis: 'Penetapan',
                                           sub_jenis: 'SubKegiatan')
                                    .sum(:anggaran).to_i
        {
          nama_opd: opd.nama_opd,
          kode_opd: opd.kode_unik_opd,
          pagu_kak: anggaran_kak,
          pagu_sipd: anggaran_sipd
        }
      end
    end
  end
end
