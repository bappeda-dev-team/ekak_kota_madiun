class UpdateProgramJob < ApplicationJob
  queue_as :default
  def perform(kode_opd, tahun, id_opd)
    request = Api::SipdClient.new(id_sipd: kode_opd, tahun: tahun, id_opd: id_opd)
    request.data_subkegiatan_all
  end
end
