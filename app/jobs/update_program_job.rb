class UpdateProgramJob < ApplicationJob
  queue_as :default
  def perform(kode_opd, tahun, id_opd)
    request = Api::SipdClient.new(kode_opd, tahun, id_opd)
    request.data_subkegiatan_all
  end
end
