class SyncPenetapanJob
  include Sidekiq::Worker
  include Sidekiq::Status::Worker
  include Sidekiq::Job

  queue_as :default
  sidekiq_options lock: :until_executed

  def perform(kode_unik_opd, tahun, bulan)
    request = Api::SipkdClient.new(kode_unik_opd, tahun, bulan)
    request.sync_penetapan
  end
end
