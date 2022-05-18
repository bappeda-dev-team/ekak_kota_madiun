class UpdateSubkegiatanJob < ApplicationJob
  queue_as :default
  def perform(kode_opd, tahun, id_opd)
    Api::SipdClient.new(id_sipd: kode_opd, tahun: tahun, id_opd: id_opd).subkegiatan_opd
  end
end
