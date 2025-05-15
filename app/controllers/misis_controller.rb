class MisisController < ApplicationController
  before_action :set_misi, only: %i[show edit update destroy]
  before_action :set_periode_lembaga, only: %i[index new edit lists create update]
  layout false, only: %i[new edit]

  # GET /misis or /misis.json
  def index
    selected_id = params[:selected]
    visi_id = params[:kode]

    @visi = Visi.includes(:misis).where(tahun_awal: @tahun_awal,
                                        tahun_akhir: @tahun_akhir,
                                        lembaga_id: @lembaga_id)

    @misis = if request.format.json?
               visi_selected = if selected_id.present?
                                 @visi.where(misis: { id: selected_id })
                               else
                                 @visi.where(id: visi_id)
                               end
               visi_selected.to_h do |visi|
                 [visi, visi.misis]
               end
             else
               @visi.to_h do |visi|
                 [visi, visi.misis]
               end
             end
  end

  def lists
    misi_dicari = params[:q]
    selected_id = params[:selected]
    @misis = Misi.where(id: selected_id)
                 .presence || Misi.all
    @misis = @misis.where("misi ILIKE ?", "%#{misi_dicari}%")
                   .where(tahun_awal: @tahun_awal,
                          tahun_akhir: @tahun_akhir)
  end

  # GET /misis/1 or /misis/1.json
  def show; end

  # GET /misis/new
  def new
    @visi = Visi.find(params[:visi_id])
    lembaga = Lembaga.find(cookies[:lembaga_id])
    @urutan_misi_terakhir = Misi.where(lembaga_id: lembaga.id, visi_id: @visi.id)
                                .last&.urutan.to_i + 1

    @misi = Misi.new(lembaga_id: lembaga.id, visi_id: @visi.id)
  end

  # GET /misis/1/edit
  def edit
    @visi = @misi.visi
    @periode = Periode.find_by(tahun_awal: @visi.tahun_awal,
                               tahun_akhir: @visi.tahun_akhir)
  end

  # POST /misis or /misis.json
  def create
    @visi = Visi.find(misi_params[:visi_id])
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
    @visi = Visi.find(misi_params[:visi_id])
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
    return if @tahun.nil?

    tahun_bener = @tahun.match(/murni|perubahan/) ? @tahun[/[^_]\d*/, 0] : @tahun
    @periode = Periode.find_tahun_rpjmd(tahun_bener)

    return if @periode.empty?

    @periode = @periode.first

    @tahun_awal = @periode.tahun_awal
    @tahun_akhir = @periode.tahun_akhir
  end

  # Only allow a list of trusted parameters through.
  def misi_params
    params.require(:misi).permit(:misi, :urutan,
                                 :keterangan, :tahun_awal, :tahun_akhir,
                                 :visi_id, :lembaga_id, :pohon_id)
  end
end
