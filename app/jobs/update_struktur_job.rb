class UpdateStrukturJob < ApplicationJob
  queue_as :default
  def perform(kode_opd, tahun, bulan)
    request = Api::SkpClient.new(kode_opd, tahun, bulan)
    request.update_struktur
  end
end
