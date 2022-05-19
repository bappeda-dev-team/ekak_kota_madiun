class UpdateKamusUsulanJob < ApplicationJob
  queue_as :default

  def perform(tahun)
    request = Api::SipdClient.new(id_sipd: '', tahun: tahun, id_opd: '')
    request.kamus_usulan_master
  end
end
