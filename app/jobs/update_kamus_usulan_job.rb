class UpdateKamusUsulanJob < ApplicationJob
  queue_as :default

  def perform(tahun)
    request = Api::SipdClient.new('', tahun, '')
    request.kamus_usulan_master
  end
end
