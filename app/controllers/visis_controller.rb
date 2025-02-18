class VisisController < ApplicationController
  before_action :set_visi, only: %i[show edit update destroy]
  before_action :set_periode_lembaga, only: %i[index new]
  layout false, only: %i[new edit]

  # GET /visis or /visis.json
  def index
    selected_id = params[:selected]

    @visis = if selected_id.present? && request.format.json?
               Visi.where(tahun_awal: @tahun_awal, tahun_akhir: @tahun_akhir,
                          lembaga_id: @lembaga_id, id: selected_id)
             else
               Visi.where(tahun_awal: @tahun_awal, tahun_akhir: @tahun_akhir,
                          lembaga_id: @lembaga_id)
             end
  end

  # GET /visis/1 or /visis/1.json
  def show; end

  # GET /visis/new
  def new
    lembaga = Lembaga.find(cookies[:lembaga_id])
    @visi = Visi.new(lembaga_id: lembaga.id)
  end

  # GET /visis/1/edit
  def edit
    @periode = Periode.find_by(tahun_awal: @visi.tahun_awal,
                               tahun_akhir: @visi.tahun_akhir)
  end

  # POST /visis or /visis.json
  def create
    @visi = Visi.new(visi_params)

    if @visi.save
      render json: { resText: 'Visi ditambahkan',
                     html_content: html_content({ visi: @visi },
                                                partial: 'visis/visi') }
        .to_json,
             status: :ok
    else
      render json: { resText: 'Terjadi kesalahan',
                     html_content: html_content({ visi: @visi },
                                                partial: 'visis/form') }
        .to_json,
             status: :unprocessable_entity
    end
  end

  # PATCH/PUT /visis/1 or /visis/1.json
  def update
    if @visi.update(visi_params)
      render json: { resText: 'Perubahan disimpan',
                     html_content: html_content({ visi: @visi },
                                                partial: 'visis/visi') }
        .to_json,
             status: :ok
    else
      render json: { resText: 'Terjadi kesalahan',
                     html_content: html_content({ visi: @visi },
                                                partial: 'visis/form') }
        .to_json,
             status: :unprocessable_entity
    end
  end

  # DELETE /visis/1 or /visis/1.json
  def destroy
    @visi.destroy

    render json: { resText: "Visi Dihapus" }.to_json, status: :accepted
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_visi
    @visi = Visi.find(params[:id])
  end

  def set_periode_lembaga
    @tahun = cookies[:tahun]
    @lembaga_id = cookies[:lembaga_id]
    @lembaga = cookies[:lembaga]
    tahun_bener = @tahun.match(/murni|perubahan/) ? @tahun[/[^_]\d*/, 0] : @tahun
    @periode = Periode.find_tahun_rpjmd(tahun_bener)

    return if @periode.empty?

    @periode = @periode.first

    @tahun_awal = @periode.tahun_awal
    @tahun_akhir = @periode.tahun_akhir
  end

  # Only allow a list of trusted parameters through.
  def visi_params
    params.require(:visi).permit(:visi, :urutan, :keterangan, :tahun_awal, :tahun_akhir, :lembaga_id)
  end
end
