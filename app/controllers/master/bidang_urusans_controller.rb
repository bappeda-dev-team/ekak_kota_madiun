class Master::BidangUrusansController < ApplicationController
  def index
    @bidang_urusans = Master::BidangUrusan.all
  end

  def sync_master_bidang_urusan
    request = Api::SipdMasterClient.new
    request.sync_master_bidang_urusans
    redirect_to master_bidang_urusan_path,
                success: "Update Bidang Urusan Selesai"
  end
end
