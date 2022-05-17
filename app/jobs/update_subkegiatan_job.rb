class UpdateSubkegiatanJob < ApplicationJob
  queue_as :default
  def perform(kode_opd, tahun, id_opd)
    Api::SipdClient.new(kode_opd, tahun, id_opd).subkegiatan_opd
  end
end
