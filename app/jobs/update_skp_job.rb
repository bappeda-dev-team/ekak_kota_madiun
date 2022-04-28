class UpdateSkpJob < ApplicationJob
  queue_as :default
  def perform(kode_opd, tahun, bulan, tipe_asn = 'asn')
    request = Api::SkpClient.new(kode_opd, tahun, bulan, tipe_asn)
    request.update_sasaran
  end
end
