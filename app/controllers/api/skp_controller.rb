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
      @status_rencana_aksi = @eselon.any? { |es| %w[eselon_4 staff].include?(es) }
      @sasaran = Sasaran.find_by(id_rencana: id_sasaran)
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
      # @opd = @kode_opd == '4.01.0.00.0.00.01.0000' ? Opd.find_by(kode_unik_opd: '4.01.0.00.0.00.01.00') : Opd.find_by(kode_unik_opd: @kode_opd)
      @opd = case @kode_opd
             when '4.01.0.00.0.00.01.0000'
               Opd.find_by(kode_unik_opd: '4.01.0.00.0.00.01.00')
             when '4.02.0.00.0.00.01.0000'
               Opd.find_by(kode_unik_opd: '4.02.0.00.0.00.01.00')
             when '2.12.2.24.0.00.01.0000'
               Opd.find_by(kode_unik_opd: '2.12.0.00.0.00.01.0000')
             when '7.01.0.00.0.00.03.0000'
               Opd.find_by(kode_unik_opd: '7.01.0.00.0.00.03.00')
             else
               Opd.find_by(kode_unik_opd: @kode_opd)
             end
      @tujuan_opds = @opd.tujuan_opds
    end

    def sasaran_opd
      @tahun = params[:tahun]
      @kode_opd = params[:kode_opd]
      @opd = Opd.find_by(kode_unik_opd: @kode_opd)
      @kepala_opd = @opd.eselon_dua_opd

      @sasaran_opds = @kepala_opd.sasarans
                                 .where("sasarans.tahun ILIKE ?", @tahun)
                                 .dengan_manual_ik
                                 .select { |s| s.strategi.present? }
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
      @user = User.find_by(nik: @nip)
      @sasarans = @user.sasaran_pohon_kinerja(tahun: @tahun)
    end
  end
end
