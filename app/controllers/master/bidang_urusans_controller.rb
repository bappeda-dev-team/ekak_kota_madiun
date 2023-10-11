class Master::BidangUrusansController < ApplicationController
  def index
    handle_filters
  end

  def sync_master_bidang_urusan
    request = Api::SipdMasterClient.new
    request.sync_master_bidang_urusans
    redirect_to master_bidang_urusan_path,
                success: "Update Bidang Urusan Selesai"
  end

  def handle_filters
    filter_query = params[:filter_query]
    if filter_query == 'bidang_urusan_tahun'
      tahun = params[:tahun]
      @bidang_urusans = Master::BidangUrusan.all.where(tahun: tahun)
    else
      @bidang_urusans = Master::BidangUrusan.all
    end
  end

  def list_bidang_urusan
    @bidang_urusans = Master::BidangUrusan.all
                                          .where.not(nama_bidang_urusan: [nil, ''])
                                          .uniq(&:kode_bidang_urusan)
  end
end
