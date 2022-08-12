class UpdateSasaranKotaJob
  include Sidekiq::Job
  include Sidekiq::Status::Worker
  include Sidekiq::Job

  queue_as :default
  sidekiq_options lock: :until_executing

  def perform(*args)
    request = Api::SkpClient.new(args[0], args[1], args[2], args[3])
    request.update_kota
  end
end
