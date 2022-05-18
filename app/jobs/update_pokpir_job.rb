class UpdatePokpirJob < ApplicationJob
  queue_as :default

  def perform(tahun)
    request = Api::SipdClient.new(id_sipd: '', tahun: tahun, id_opd: '')
    request.pokpir_master
  end
end
