class SyncJabatanJob
  include Sidekiq::Worker
  include Sidekiq::Job

  queue_as :default
  sidekiq_options lock: :until_executed

  def perform(kode_unik_opd, tahun)
    request = Api::SkpClient.new(kode_unik_opd, tahun)
    request.sync_jabatan
  end
end
