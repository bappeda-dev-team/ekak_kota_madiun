class CrosscuttingsController < ApplicationController
  before_action :set_crosscutting, only: %i[show edit update destroy]
  before_action :set_tahun_opd

  layout false

  # GET /crosscuttings or /crosscuttings.json
  def index; end

  # GET /crosscuttings/1 or /crosscuttings/1.json
  def show
    @crosscuttings = @crosscutting.where(strategi_id: params[:strategi_id])
  end

  def new
    @partial = params[:partial]
    strategi_id = params[:strategi_id]
    @strategi = Strategi.find(strategi_id)
    @crosscutting = @strategi.crosscuttings.build
    @crosscutting.mitras.build
  end

  def create
    @partial = params[:crosscutting][:partial]
    @crosscutting = Crosscutting.new(crosscutting_params)

    if @crosscutting.save
      strategi = @crosscutting.strategi
      render json: { resText: "Crosscutting berhasil diperbarui",
                     html_content: html_content({ pohon: strategi },
                                                partial: "pohon_kinerja_opds/#{@partial}") }.to_json,
             status: :ok
    else
      render json: { resText: "Tidak ada perubahan",
                     html_content: html_content({ pohon: @crosscutting.strategi },
                                                partial: "pohon_kinerja_opds/#{@partial}") }.to_json,
             status: :ok
    end
  end

  def internal
    @crosscutting = Crosscutting.new
    render partial: "crosscutting_internal", locals: { crosscutting: @crosscutting }
  end

  def external
    @crosscutting = Crosscutting.new
    render partial: "crosscutting_external", locals: { crosscutting: @crosscutting }
  end

  def external_pemerintah
    @crosscutting = Crosscutting.new
    render partial: "crosscutting_external_pemerintah", locals: { crosscutting: @crosscutting }
  end

  def external_non_pemerintah
    @crosscutting = Crosscutting.new
    render partial: "crosscutting_external_non_pemerintah", locals: { crosscutting: @crosscutting }
  end

  # GET /crosscuttings/1/edit
  def edit; end

  # PATCH/PUT /crosscuttings/1 or /crosscuttings/1.json
  def update; end

  private

  def set_tahun_opd
    @tahun = cookies[:tahun]
    @kode_opd = cookies[:opd]
    @opd = Opd.find_by(kode_unik_opd: @kode_opd)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_crosscutting
    @crosscutting = Crosscutting.new(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def crosscutting_params
    params.require(:crosscutting).permit(:tipe_crosscutting, :strategi_id, :opd_pelaksana,
                                         :tipe_instansi, :nama_instansi,
                                         mitras_attributes: %i[jenis_mitra nama_kerjasama penjelasan_kerjasama tahun_kerjasama _destroy],
                                         inovasi_tims_attributes: [:jenis_inovasi, :nama_inovasi, :nilai_kebaruan, :inovasi_masyarakat_id, :_destroy,
                                                                   { tims_attributes: [:nama_tim, { anggota_tims_attributes: %i[role nama _destroy] }] }])
  end
end
