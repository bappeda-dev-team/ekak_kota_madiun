module Api
  class SkpController < ActionController::API
    # skip_before_action :verify_authenticity_token
    # skip_before_action :authenticate_user!

    respond_to :json

    def sasaran_kinerja_pegawai
      @nip = params[:nip]
      @tahun = params[:tahun]
      @user = User.find_by(nik: @nip)
      # @sasarans = @user.sasaran_asn_sync_skp(tahun: @tahun)
      @sasarans = @user.sasaran_asn_sync_skp(tahun: @tahun)
    end

    def indikator_sasaran_kinerja_pegawai
      id_sasaran = params[:id_sasaran]
      @nip = params[:nip]
      @tahun = params[:tahun]
      @user = User.find_by(nik: @nip)
      @sasaran = Sasaran.find_by(id_rencana: id_sasaran)
      @indikators = @sasaran.indikator_sasarans
    end

    def rencana_aksi_pegawai
      id_sasaran = params[:id_sasaran]
      @nip = params[:nip]
      @tahun = params[:tahun]
      @user = User.find_by(nik: @nip)
      @eselon = @user.role_asn
      @status_rencana_aksi = true
      @sasaran = @user.sasarans.find_by(id_rencana: id_sasaran)
      @tahapans = @sasaran.tahapan_renaksi
    end

    def manual_ik_pegawai
      # id_sasaran = params[:id_sasaran]
      id_indikator = params[:id_indikator]
      @nip = params[:nip]
      @tahun = params[:tahun]
      @user = User.find_by(nik: @nip)
      # @sasaran = Sasaran.find_by(id_rencana: id_sasaran)
      @indikator_sasaran = IndikatorSasaran.find(id_indikator)
      @sasaran = @indikator_sasaran.sasaran
    end

    def sasaran_pegawai
      @nip = params[:nip]
      @tahun = params[:tahun]
      @user = User.find_by(nik: @nip)
      @sasarans = @user.sasaran_asn_sync_skp(tahun: @tahun)
    end

    def tujuan_opd
      @tahun = params[:tahun]
      @kode_opd = params[:kode_opd]
      @opd = Opd.find_by(kode_unik_opd: @kode_opd)
      if @opd.nil?
        render json: {
          message: 'OPD tidak ditemukan',
          errors: {
            kode_opd: @kode_opd
          }
        }, status: :not_found
        return
      end
      tahun_bener = @tahun.match(/murni|perubahan/) ? @tahun[/[^_]\d*/, 0] : @tahun
      periode = Periode.find_tahun_all(tahun_bener)
      if periode.empty?
        render json: {
          message: 'Periode tahun tidak ditemukan',
          errors: {
            tahun: @tahun
          }
        }, status: :not_found
        return
      end
      @periode = periode.first
      @tahun_awal = @periode.tahun_awal.to_i
      @tahun_akhir = @periode.tahun_akhir.to_i
      @range = (@tahun_awal..@tahun_akhir)

      @tujuan_opds = @opd.tujuan_opds
                         .by_periode(tahun_bener)
    rescue ActiveRecord::StatementInvalid
      render json: {
        message: 'Tahun tidak valid',
        errors: {
          tahun: @tahun
        }
      }, status: :unprocessable_entity
    end

    def sasaran_opd
      @tahun = params[:tahun]
      @kode_opd = params[:kode_opd]
      queries = PohonKinerjaOpdQueries.new(tahun: @tahun, kode_opd: @kode_opd)
      @opd = queries.opd
      @kepala_opd = @opd.eselon_dua_opd
      strategi_opd = queries.strategi_opd
      @sasaran_opds = strategi_opd.map(&:sasarans).compact.flatten
    end

    def sasaran_pohon_kinerja
      @nip = params[:nip]
      @tahun = params[:tahun]
      @user = User.find_by(nik: @nip)
      @eselo_user = @user.eselon_user
      @sasarans = @user.sasaran_pohon_kinerja(tahun: @tahun)
    end

    def sasaran_pohon_kinerja_pegawai
      @nip = params[:nip]
      @tahun = params[:tahun]
      @user = User.find_by!(nik: @nip)
      @sasarans = @user.sasaran_pohon_kinerja(tahun: @tahun)
    end

    def faktor_penghambat_skp
      id_rencana = params[:id_rencana]
      skp_client = Api::SkpClient.new(id_rencana, '')
      @penghambats = skp_client.get_faktor_penghambat.uniq
    end

    def tujuan_kota
      @tahun = params[:tahun]

      tahun_bener = @tahun.match(/murni|perubahan/) ? @tahun[/[^_]\d*/, 0] : @tahun
      @periode = Periode.find_tahun(tahun_bener)
      @tahun_awal = @periode.tahun_awal.to_i
      @tahun_akhir = @periode.tahun_akhir.to_i
      @range = (@tahun_awal..@tahun_akhir)

      @tujuan_kota = TujuanKota.all.includes([:indikator_tujuans])
                               .by_periode(tahun_bener)
    end

    def sasaran_kota
      @tahun = params[:tahun]
      @sasaran_kota = Pohon.where(pohonable_type: %w[SubTematik SubSubTematik],
                                  tahun: @tahun).map(&:pohonable)
                           .compact
                           .select { |sasaran| sasaran.sasaran_kotum.present? }
                           .reject { |sasaran| sasaran.sasaran_kotum.sasaran.blank? }
    end
  end
end
