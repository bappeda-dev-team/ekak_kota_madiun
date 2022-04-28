class UpdatePokpirJob < ApplicationJob
  queue_as :default

  def perform(tahun)
    request = Api::SipdClient.new('', tahun, '')
    request.pokpir_master
  end
end
