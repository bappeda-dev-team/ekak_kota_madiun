class ProgramKegiatansController < ApplicationController
  before_action :set_programKegiatan,
                only: %i[show edit update destroy show_to_kak kak_detail kak_renaksi kak_waktu pdf_rka]
  before_action :set_dropdown, only: %i[new edit]

  layout false, only: %i[show_to_kak kak_detail kak_renaksi kak_waktu]

  def index
    # TODO: refactor untuk json query
    param = params[:q] || ''
    # FIXME REFACTOR TOO MUCH LOGIC
    @programKegiatans = ProgramKegiatan.where('kode_opd ILIKE ?', "%#{current_user.kode_opd}%")
                                       .where('nama_subkegiatan ILIKE ?', "%#{param}%")
    if current_user.pegawai_kelurahan?
      @programKegiatans = @programKegiatans.select { |program| program.nama_opd_pemilik.upcase.split(/KELURAHAN/, 2).last.strip == current_user.petunjuk_kelurahan }
    end
  end

  def admin_program_kegiatan
    @filter_url = 'filter_program'
  end

  def admin_program
    @filter_url = 'filter_program_saja'
    render :admin_program_kegiatan
  end

  def admin_kegiatan
    @filter_url = 'filter_kegiatan'
    render :admin_program_kegiatan
  end

  def new
    @programKegiatan = ProgramKegiatan.new
  end

  def show; end

  def show_to_kak; end

  def kak_detail; end

  def kak_renaksi; end

  def kak_waktu; end

  def new_kak_format
    @program_kegiatan = ProgramKegiatan.find(params[:id])
    render 'new_kak_format'
  end

  def pdf_kak
    @nama_file = ProgramKegiatan.find(params[:id]).nama_subkegiatan
    @tahun = params[:tahun] || Time.now.year
    @waktu = Time.now.strftime("%d_%m_%Y_%H_%M")
    @filename = "Laporan_KAK_#{@nama_file}_#{@waktu}.pdf"
    @program_kegiatan = ProgramKegiatan.find(params[:id])
  end

  def laporan_rka
    @program_kegiatans = ProgramKegiatan.joins(:sasarans).where(sasarans: { nip_asn: current_user.nik }).where.not(sasarans: { id: nil, anggaran: nil }).group(:id)
  end

  def pdf_rka
    @nama_file = ProgramKegiatan.find(params[:id]).nama_subkegiatan
    @tahun = params[:tahun] || Time.now.year
    @waktu = Time.now.strftime("%d_%m_%Y_%H_%M")
    @filename = "Laporan_RAB_#{@nama_file}_#{@waktu}.pdf"
  end

  def edit; end

  def create
    @programKegiatan = ProgramKegiatan.new(programKegiatan_params)
    respond_to do |format|
      if @programKegiatan.save
        format.js { render '_notifikasi_update', locals: { message: 'Program Kegiatan berhasil dibuat', status_icon: 'success', form_name: 'form-programkegiatan', type: 'create' } }
        format.html { redirect_to program_kegiatans_url, success: 'Program Kegiatan Dibuat' }
      else
        format.html { render :new, error: 'Gagal menyimpan Program Kegiatan' }
      end
    end
  end

  def update
    sleep 1
    respond_to do |format|
      if @programKegiatan.update(programKegiatan_params)
        format.js { render '_notifikasi_update', locals: { message: 'Program Kegiatan berhasil diupdate', status_icon: 'success', form_name: 'form-programkegiatan', type: 'update' } }
        format.html { redirect_to program_kegiatans_url, success: 'Program Kegiatan diupdate' }
      else
        format.html { render :edit, error: 'Program Kegiatan Gagal diupdate' }
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
