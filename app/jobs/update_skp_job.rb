class UpdateSkpJob < ApplicationJob
  queue_as :default
  after_perform :show_message
  def perform(kode_opd, tahun, bulan)
    request = Api::SkpClient.new(kode_opd, tahun, bulan)
    request.update_sasaran
  end

  private

  def show_message
    puts 'Sukses Menarik Data'
  end
end
