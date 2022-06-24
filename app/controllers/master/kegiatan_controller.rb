class Master::KegiatanController < ApplicationController
  def index
    @kegiatans = Master::Kegiatan.all
  end

  def sync_master_kegiatan
    tahun = params[:tahun]
    request = Api::SipdMasterClient.new(tahun: tahun)
    request.sync_master_kegiatan
    redirect_to master_kegiatans_path,
                success: "Update Master Kegiatan Selesai"
  end
end
