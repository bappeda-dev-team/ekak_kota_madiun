class PaguAnggaransController < ApplicationController
  include ActionView::Helpers::NumberHelper
  before_action :params_from_link, only: %i[new edit]
  before_action :set_pagu, only: %i[edit]

  def new
    @pagu_anggaran = PaguAnggaran.new
    @kode_opd = current_user.opd.kode_opd

    render partial: 'form_pagu_anggaran'
  end

  def edit
    @kode_opd = current_user.opd.kode_opd
    render partial: 'form_edit_pagu_anggaran'
  end

  def create
    id_anggaran = params[:pagu_anggaran]["id_anggaran"]
    @anggaran = Anggaran.find_by_id(id_anggaran)
    @pagu_anggaran = @anggaran.create_pagu_anggaran(pagu_anggarans_params)
    respond_to do |format|
      if @pagu_anggaran.save
        format.json do
          render json: { results: {
            anggaran: "Rp. #{number_with_delimiter(@pagu_anggaran.anggaran)}",
            total: "Rp. #{number_with_delimiter(@anggaran.total_anggaran_penetapan)}",
            jumlah: "Rp. #{number_with_delimiter(@anggaran.tahapan.anggaran_tahapan_penetapan)}",
            parent: @anggaran.kode_rekening_gp
          },
                         message: 'Tersimpan' },
                 status: :accepted
        end
      else
        format.json { render json: { results: '', message: 'Tidak Tersimpan' }, status: :unprocessable_entity }
      end
    end
  end

  def update
    id_anggaran = params[:pagu_anggaran]["id_anggaran"]
    @anggaran = Anggaran.find_by_id(id_anggaran)
    @pagu_anggaran = PaguAnggaran.find(params[:id])
    respond_to do |format|
      if @pagu_anggaran.update(pagu_anggarans_params)
        format.json do
          render json: { results: {
            anggaran: "Rp. #{number_with_delimiter(@pagu_anggaran.anggaran)}",
            total: "Rp. #{number_with_delimiter(@anggaran.total_anggaran_penetapan)}",
            jumlah: "Rp. #{number_with_delimiter(@anggaran.tahapan.anggaran_tahapan_penetapan)}",
            parent: @anggaran.kode_rekening_gp
          },
                         message: 'Tersimpan' },
                 status: :accepted
        end
      else
        format.json { render json: { results: '', message: 'Tidak Tersimpan' }, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_pagu
    @pagu_anggaran = PaguAnggaran.find(params[:id])
  end

  def set_anggaran
    @anggaran = Anggaran.find_by_id(params[:anggaran])
    @jumlah = if @anggaran.pagu_anggaran.present?
                @anggaran.anggaran_penetapan
              else
                @anggaran.jumlah
              end
    @kode = @anggaran.id
  end

  def params_from_link
    set_anggaran
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
