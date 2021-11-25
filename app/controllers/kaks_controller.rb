class KaksController < ApplicationController
  before_action :set_kak, only: %i[ show edit update destroy ]
  before_action :set_dropdown, only: %i[ new edit ]

  # GET /kaks or /kaks.json
  def index
    @kaks = Kak.all
  end

  # GET /kaks/1 or /kaks/1.json
  def show
  end

  # GET /kaks/new
  def new
    @kak = Kak.new
  end

  # GET /kaks/1/edit
  def edit
  end

  # POST /kaks or /kaks.json
  def create
    @kak = Kak.new(kak_params)

    respond_to do |format|
      if @kak.save
        format.html { redirect_to @kak, notice: "Kak was successfully created." }
        format.json { render :show, status: :created, location: @kak }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @kak.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /kaks/1 or /kaks/1.json
  def update
    respond_to do |format|
      if @kak.update(kak_params)
        format.html { redirect_to @kak, notice: "Kak was successfully updated." }
        format.json { render :show, status: :ok, location: @kak }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @kak.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /kaks/1 or /kaks/1.json
  def destroy
    @kak.destroy
    respond_to do |format|
      format.html { redirect_to kaks_url, notice: "Kak was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_kak
      @kak = Kak.find(params[:id])
    end
    
    def set_dropdown
      # TODO : update  -> agar sesuai dengan opd masing masing
      @program_kegiatans = ProgramKegiatan.all
      @pks = Pk.all
    end

    # Only allow a list of trusted parameters through.
    def kak_params
      params.require(:kak).permit(:pk_id ,:program_kegiatan_id ,:dasar_hukum, :tujuan, :penerima_manfaat, :data_terpilah, :akses, :partisipasi, :kontrol, :manfaat, :penyebab_internal, :penyebab_external, :permasalahan_umum, :permasalahan_gender, :resiko, :lokasi_pelaksanaan)
    end
end
