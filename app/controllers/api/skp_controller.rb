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

    def sasaran_pohon_kinerja
      @nip = params[:nip]
      @tahun = params[:tahun]
      @user = User.find_by(nik: @nip)
      @sasarans = @user.sasaran_pohon_kinerja(tahun: @tahun)
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
      @eselon = @user.eselon_user.name
      @status_rencana_aksi = case @eselon
                             when 'eselon_4' || 'staff'
                               true
                             else
                               false
                             end
      @sasaran = Sasaran.find_by(id_rencana: id_sasaran)
      @tahapans = @sasaran.tahapans
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

    def sasaran_pohon_kinerja_pegawai
      @nip = params[:nip]
      @tahun = params[:tahun]
      @user = User.find_by(nik: @nip)
      @sasarans = @user.sasaran_pohon_kinerja(tahun: @tahun)
    end

    def tujuan_opd
      @tahun = params[:tahun]
      @kode_opd = params[:kode_opd]
      @opd = Opd.find_by(kode_unik_opd: @kode_opd)
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
  end
end