class UpdateSkpJob < ApplicationJob
  queue_as :default
  def perform(kode_opd, tahun, bulan)
    request = Api::SkpClient.new(kode_opd, tahun, bulan)
    request.update_sasaran
  end
end
