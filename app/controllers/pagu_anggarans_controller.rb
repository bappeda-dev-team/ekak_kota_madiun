class PaguAnggaransController < ApplicationController
  def new
    @pagu_anggaran = PaguAnggaran.new
    @anggaran = params[:anggaran] || 0

    render partial: 'form_pagu_anggaran'
  end

  def edit; end

  def set_pagu
    @pagu_anggaran = PaguAnggaran.find(params[:id])
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
