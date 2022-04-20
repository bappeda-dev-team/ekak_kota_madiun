class UpdateProgramJob < ApplicationJob
  queue_as :default
  after_perform :show_message
  def perform(kode_opd, tahun, id_opd)
    request = Api::SipdClient.new(kode_opd, tahun, id_opd)
    request.data_subkegiatan_all
  end

  private

  def show_message
    puts 'Sukses Menarik Data'
  end
end
