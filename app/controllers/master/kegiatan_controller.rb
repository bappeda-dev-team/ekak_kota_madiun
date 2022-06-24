class Master::KegiatanController < ApplicationController
  def index
    handle_filters
  end

  def sync_master_kegiatan
    tahun = params[:tahun]
    request = Api::SipdMasterClient.new(tahun: tahun)
    request.sync_master_kegiatan
    redirect_to master_kegiatans_path,
                success: "Update Master Kegiatan Selesai"
  end

  def handle_filters
    filter_query = params[:filter_query]
    if filter_query == 'tahun'
      tahun = params[:tahun]
      @kegiatans = Master::Kegiatan.where(tahun: tahun)
    else
      @kegiatans = Master::Kegiatan.all
    end
  end
end
