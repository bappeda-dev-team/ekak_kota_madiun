class GendersController < ApplicationController
  def gender
    # open gender html
  end

  def pdf_gender
    @nama_file = ProgramKegiatan.find(params[:id]).nama_subkegiatan
    @tahun = params[:tahun] || Time.now.year
    @waktu = Time.now.strftime("%d_%m_%Y_%H_%M")
    @filename = "Laporan_GAP_#{@nama_file}_#{@waktu}.pdf"
    @program_kegiatan = ProgramKegiatan.find(params[:id])
    render 'kak_gender.pdf' # delete this line to alter
  end
end
