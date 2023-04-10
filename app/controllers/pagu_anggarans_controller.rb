class PaguAnggaransController < ApplicationController
  before_action :params_from_link, only: %i[new edit]
  before_action :set_pagu, only: %i[edit]

  def new
    @pagu_anggaran = PaguAnggaran.new
    @kode_opd = current_user.opd.kode_opd

    render partial: 'form_pagu_anggaran'
  end

  def edit
    @kode_opd = current_user.opd.kode_opd
    render partial: 'form_pagu_anggaran'
  end

  def create
    id_anggaran = params[:pagu_anggaran]["id_anggaran"]
    @anggaran = Anggaran.find_by_id(id_anggaran)
    @tahapan = @anggaran.tahapan
    @sasaran = @tahapan.sasaran
    @pagu_anggaran = PaguAnggaran.new(pagu_anggarans_params)
    respond_to do |format|
      if @pagu_anggaran.save
        format.html { redirect_to edit_penetapan_sasaran_tahapan_anggarans_path(@sasaran, @tahapan) }
      else
        format.html { redirect_to edit_penetapan_sasaran_tahapan_anggarans_path(@sasaran, @tahapan), status: :unprocessable_entity}
      end
    end

  end

  private

  def set_pagu
    @pagu_anggaran = PaguAnggaran.find(params[:id])
  end

  def params_from_link
    @anggaran = Anggaran.find_by_id(params[:anggaran])
    @kode = params[:kode]
    @kode_belanja = params[:kode_belanja]
    @kode_sub_belanja = params[:kode_sub_belanja]
    @jenis = params[:jenis]
    @sub_jenis = params[:sub_jenis]
    @tahun = params[:tahun]
  end

  def pagu_anggarans_params
    params.require(:pagu_anggaran).permit(:kode, :kode_opd,
                                          :kode_belanja,
                                          :kode_sub_belanja,
                                          :jenis, :sub_jenis,
                                          :keterangan,
                                          :anggaran, :tahun)
  end
end
