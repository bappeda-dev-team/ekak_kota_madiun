class UpdateRenstraJob < ApplicationJob
  include Sidekiq::Worker
  include Sidekiq::Status::Worker
  include Sidekiq::Job
  queue_as :default
  sidekiq_options lock: :until_executed

  def perform(*_args)
    request = Api::SipdClient.new(id_opd: id_opd)
    request.renstra_opd
  end
end
