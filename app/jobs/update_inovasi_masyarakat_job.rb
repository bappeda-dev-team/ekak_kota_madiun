class UpdateInovasiMasyarakatJob < ApplicationJob
  queue_as :default
  def perform
    request = Api::AwaksigapClient.new
    request.update_inovasi_masyarakat
  end
end
