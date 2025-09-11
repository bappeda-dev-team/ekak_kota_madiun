class EncryptNikJob
  include Sidekiq::Job

  def perform(nama, nip, nik_asli)
    # request ke server enkripsi
    request = Api::SandiDataClient.new(nama, nip, nik_asli)
    request.encrypt_nik
  end
end
