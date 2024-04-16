class SyncPenetapanJob
  include Sidekiq::Worker
  include Sidekiq::Job

  queue_as :default
  sidekiq_options lock: :until_executed

  def perform(kode_unik_opd, tahun, bulan, kode_opd, tahun_asli)
    request = Api::SipkdClient.new(kode_unik_opd, tahun, bulan, kode_opd, tahun_asli)
    request.sync_penetapan
  end
end
