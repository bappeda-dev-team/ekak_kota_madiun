class UpdateProgramJob < ApplicationJob
  queue_as :default
  after_perform :show_message
  def perform(_kode_opd, _tahun, _bulan)
    request = Api::SipdClient.new('test', 'test')
    request.data_master_program
  end

  private

  def show_message
    puts 'Sukses Menarik Data'
  end
end
