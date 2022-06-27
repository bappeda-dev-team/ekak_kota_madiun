class Master::UrusansController < ApplicationController
  def index
    @urusans = Master::Urusan.all
  end

  def sync_master_urusan
    request = Api::SipdMasterClient.new
    request.sync_master_urusans
    redirect_to master_urusan_path,
                success: "Update Urusan Selesai"
  end
end
