class UpdateDataOpdJob < ApplicationJob
  queue_as :default

  def perform(tahun)
    Api::SipdClient.new(tahun: tahun).opd_master
  end
end
