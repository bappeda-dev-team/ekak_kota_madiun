class GendersController < ApplicationController
  def gender
    @program_kegiatans = ProgramKegiatan.joins(:sasarans).where(sasarans: { nip_asn: current_user.nik }).group(:id)
    # open gender html
  end

  def pdf_gender
    @nama_file = ProgramKegiatan.find(params[:id]).nama_subkegiatan
    @tahun = params[:tahun] || Time.now.year
    @waktu = Time.now.strftime("%d_%m_%Y_%H_%M")
    @filename = "Laporan_GAP_#{@nama_file}_#{@waktu}.pdf"
    @program_kegiatan = ProgramKegiatan.find(params[:id])
    # render 'kak_gender.pdf' # delete this line to alter
    render 'pdf_gap.pdf' # delete this line to alter
  end
end
