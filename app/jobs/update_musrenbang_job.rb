class UpdateMusrenbangJob < ApplicationJob
  queue_as :default

  def perform(tahun)
    request = Api::SipdClient.new('', tahun, '')
    request.musrenbang_master
  end
end
