class EncryptNikJob
  include Sidekiq::Worker
  include Sidekiq::Job
  queue_as :default
  sidekiq_options lock: :until_executed

  def perform(nama, nip, nik_asli)
     # request ke server enkripsi
    request = Api::SandiDataClient.new(nama, nip, nik_asli)
    request.encrypt_nik
  end
end
