class Master::OutputKegiatansController < ApplicationController
  def index
    handle_filters
  end

  def sync_master_output_kegiatans
    tahun = params[:tahun]
    request = Api::SipdMasterClient.new(tahun: tahun)
    request.sync_master_output_kegiatans
    redirect_to master_output_path,
                success: "Update Master Output Kegiatan Selesai"
  end
  # TODO: OPTIMIZE AND SECURE
  def handle_filters
    filter_query = params[:filter_query]
    if filter_query == 'opd'
      opd = params[:opd]
      @output_kegiatans = Master::OutputKegiatan.where(id_skpd: opd)
    else
      @output_kegiatans = Master::OutputKegiatan.all
    end
  end
end
