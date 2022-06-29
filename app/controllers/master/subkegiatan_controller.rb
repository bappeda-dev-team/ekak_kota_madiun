class Master::SubkegiatanController < ApplicationController
  include Pagy::Backend

  def index
    @pagy, @subkegiatans = pagy(Master::Subkegiatan.all, items: 15)
  end

  def sync_master_subkegiatan
    tahun = params[:tahun]
    id_giat = params[:id_giat]
    request = Api::SipdMasterClient.new(tahun: tahun, id: id_giat)
    request.sync_master_subkegiatan
    redirect_to master_subkegiatans_path,
                success: "Update Master Sub Kegiatan Selesai"
  end

  def sync_master_subkegiatan_all
    tahun = params[:tahun]
    kegiatans = Master::Kegiatan.where(tahun: tahun)
    kegiatans.each do |kegiatan|
      request = Api::SipdMasterClient.new(tahun: tahun, id: kegiatan.id_kegiatan_sipd)
      request.sync_master_subkegiatan
    end
  end
end
