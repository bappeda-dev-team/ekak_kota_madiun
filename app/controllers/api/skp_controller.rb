module Api
  class SkpController < ActionController::API
    # skip_before_action :verify_authenticity_token
    # skip_before_action :authenticate_user!

    respond_to :json

    def sasaran_kinerja_pegawai
      @nip = params[:nip]
      @tahun = params[:tahun]
      @user = User.find_by(nik: @nip)
      @sasarans = @user.sasaran_asn_sync_skp(tahun: @tahun)
    end
  end
end
