class Master::UrusansController < ApplicationController
  def index
    handle_filters
  end

  def sync_master_urusan
    request = Api::SipdMasterClient.new
    request.sync_master_urusans
    redirect_to master_urusan_path,
                success: "Update Urusan Selesai"
  end

  def handle_filters
    filter_query = params[:filter_query]
    if filter_query == 'urusan_tahun'
      tahun = params[:tahun]
      @urusans = Master::Urusan.all.where(tahun: tahun)
    else
      @urusans = Master::Urusan.all
    end
  end
end
