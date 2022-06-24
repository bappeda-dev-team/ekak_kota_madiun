class Master::SubkegiatanController < ApplicationController
  def index
    @subkegiatans = Master::Subkegiatan.all
  end

  def sync_master_subkegiatan
    tahun = params[:tahun]
    id_giat = params[:id_giat]
    request = Api::SipdMasterClient.new(tahun: tahun, id: id_giat)
    request.sync_master_subkegiatan
    redirect_to master_subkegiatans_path,
                success: "Update Master Program Selesai"
  end
end
