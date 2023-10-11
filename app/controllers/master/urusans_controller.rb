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

  def list_urusan
    param = params[:q] || ""

    @urusans = Master::Urusan.all
                             .where("nama_urusan ILIKE ?", "%#{param}%")
                             .where.not(nama_urusan: [nil, ''])
                             .uniq(&:kode_urusan)
  end
end
