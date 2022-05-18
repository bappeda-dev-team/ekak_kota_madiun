class UpdateDetailProgramJob < ApplicationJob
  queue_as :default
  def perform(kode_opd, tahun, id_opd, id_program)
    Api::SipdClient.new(id_sipd: kode_opd, tahun: tahun, id_opd: id_opd, id_program: id_program).detail_master_program
  end
end
