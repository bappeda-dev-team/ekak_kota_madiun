class SyncPaguKakJob
  include Sidekiq::Worker
  include Sidekiq::Status::Worker
  include Sidekiq::Job

  queue_as :default
  sidekiq_options lock: :until_executed

  def perform(*args)
    tahun, kode_opd = args
    request = TotalAnggaran.new(kode_opd, tahun)
    request.sync_pagu_kak
  end
end
