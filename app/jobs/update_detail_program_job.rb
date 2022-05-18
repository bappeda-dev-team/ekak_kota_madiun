class UpdateDetailProgramJob < ApplicationJob
  queue_as :default
  def perform(kode_opd, tahun, id_opd, id_program)
    Api::SipdClient.new(kode_opd, tahun, id_opd, id_program).detail_master_program
  end
end
