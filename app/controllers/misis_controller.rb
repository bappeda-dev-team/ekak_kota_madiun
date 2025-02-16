class MisisController < ApplicationController
  before_action :set_misi, only: %i[show edit update destroy]
  before_action :set_periode_lembaga, only: %i[index new]
  layout false, only: %i[new edit]

  # GET /misis or /misis.json
  def index
    @misis = Visi.where(tahun_awal: @tahun_awal, tahun_akhir: @tahun_akhir,
                        lembaga_id: @lembaga_id)
                 .to_h do |visi|
      [visi, visi.misis]
    end
  end

  # GET /misis/1 or /misis/1.json
  def show; end

  # GET /misis/new
  def new
    @visi = Visi.find(params[:visi_id])
    lembaga = Lembaga.find(cookies[:lembaga_id])
    @misi = Misi.new(tahun_awal: @tahun_awal, tahun_akhir: @tahun_akhir,
                     lembaga_id: lembaga.id, visi_id: @visi.id)
  end

  # GET /misis/1/edit
  def edit
    @visi = @misi.visi
  end

  # POST /misis or /misis.json
  def create
    @misi = Misi.new(misi_params)

    if @misi.save
      render json: { resText: 'Misi ditambahkan',
                     html_content: html_content({ misi: @misi },
                                                partial: 'misis/misi') }
        .to_json,
             status: :ok
    else
      render json: { resText: 'Terjadi kesalahan',
                     html_content: html_content({ misi: @misi },
                                                partial: 'misis/form') }
        .to_json,
             status: :unprocessable_entity
    end
  end

  # PATCH/PUT /misis/1 or /misis/1.json
  def update
    if @misi.update(misi_params)
      render json: { resText: 'Perubahan disimpan',
                     html_content: html_content({ misi: @misi },
                                                partial: 'misis/misi') }
        .to_json,
             status: :ok
    else
      render json: { resText: 'Terjadi kesalahan',
                     html_content: html_content({ misi: @misi },
                                                partial: 'misis/form') }
        .to_json,
             status: :unprocessable_entity
    end
  end

  # DELETE /misis/1 or /misis/1.json
  def destroy
    @misi.destroy

    render json: { resText: "Misi Dihapus" }.to_json, status: :accepted
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_misi
    @misi = Misi.find(params[:id])
  end

  def set_periode_lembaga
    @tahun = cookies[:tahun]
    @lembaga_id = cookies[:lembaga_id]
    @lembaga = cookies[:lembaga]
    tahun_bener = @tahun.match(/murni|perubahan/) ? @tahun[/[^_]\d*/, 0] : @tahun
    @periode = Periode.find_tahun(tahun_bener)
    @tahun_awal = @periode.tahun_awal
    @tahun_akhir = @periode.tahun_akhir
  end

  # Only allow a list of trusted parameters through.
  def misi_params
    params.require(:misi).permit(:misi, :urutan,
                                 :keterangan, :tahun_awal, :tahun_akhir,
                                 :visi_id, :lembaga_id)
  end
end
