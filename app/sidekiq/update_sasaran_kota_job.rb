class UpdateSasaranKotaJob
  include Sidekiq::Job

  def perform(*args)
    Api::SkpClient.new(args[0], args[1], args[2], args[3]).update_kota
  end
end
