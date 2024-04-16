class UpdateRenstraJob
  include Sidekiq::Worker
  include Sidekiq::Job
  queue_as :default
  sidekiq_options lock: :until_executed

  def perform(id_opd)
    request = Api::SipdClient.new(id_sipd: id_opd)
    request.renstra_opd
  end
end
