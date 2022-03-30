class ProgramKegiatansController < ApplicationController
  before_action :set_programKegiatan,
                only: %i[show edit update destroy show_to_kak kak_detail kak_renaksi kak_waktu pdf_rka]
  before_action :set_dropdown, only: %i[new edit]

  layout false, only: %i[show_to_kak kak_detail kak_renaksi kak_waktu]

  def index
    # TODO: refactor untuk json query
    param = params[:q] || ''
    @programKegiatans = ProgramKegiatan.where('kode_opd ILIKE ?', "%#{current_user.kode_opd}%")
                                       .where('nama_subkegiatan ILIKE ?', "%#{param}%")
  end

  def admin_program_kegiatan
    @programKegiatans = ProgramKegiatan.includes([:subkegiatan_tematik]).all
    render 'index'
  end

  def new
    @programKegiatan = ProgramKegiatan.new
  end

  def show; end

  def show_to_kak; end

  def kak_detail; end

  def kak_renaksi; end

  def kak_waktu; end

  def laporan_rka
    @programKegiatans = ProgramKegiatan.includes(:sasarans).where.not(sasarans: { id: nil, anggaran: nil })
  end

  def pdf_rka
    @filename = 'laporan_rka.pdf'
  end

  def edit; end

  def create
    @programKegiatan = ProgramKegiatan.new(programKegiatan_params)
    respond_to do |format|
      if @programKegiatan.save
        format.html { redirect_to @programKegiatan, notice: 'Program Kegiatan Dibuat' }
      else
        format.html { render :new, notice: 'Gagal menyimpan Program Kegiatan' }
      end
    end
  end

  def update
    sleep 1
    respond_to do |format|
      if @programKegiatan.update(programKegiatan_params)
        format.html { redirect_to @programKegiatan, notice: 'Program Kegiatan diupdate' }
        format.js
      else
        format.html { render :edit, notice: 'Program Kegiatan Gagal diupdate' }
      end
    end
  end

  def destroy
    @programKegiatan.destroy
    respond_to do |format|
      format.html { redirect_to program_kegiatans_url, notice: 'Program dihapus' }
    end
  end

  private

  def set_programKegiatan
    @programKegiatan = ProgramKegiatan.find(params[:id])
  end

  def set_dropdown
    @opds = Opd.all
  end

  def programKegiatan_params
    params.require(:program_kegiatan).permit!
  end
end
