class RealisasisController < ApplicationController
  before_action :set_realisasi, only: %i[show edit update destroy]
  layout false, only: %i[new edit]

  # GET /realisasis or /realisasis.json
  def index
    @realisasis = Realisasi.all
  end

  # GET /realisasis/1 or /realisasis/1.json
  def show; end

  # GET /realisasis/new
  def new
    periode = params[:periode].split('-')
    @tahun_awal = periode[0].to_i
    @tahun_akhir = periode[-1].to_i
    @periode = (@tahun_awal..@tahun_akhir)
    @indikator = Indikator.find(params[:indikator])
    @targets = @indikator.targets.where(tahun: @periode)
    @realisasi = @indikator.realisasis.build if @indikator.realisasis.empty?
  end

  # GET /realisasis/1/edit
  def edit; end

  # POST /realisasis or /realisasis.json
  def create
    @realisasi = Realisasi.new(realisasi_params)

    respond_to do |format|
      if @realisasi.save
        format.html { redirect_to realisasi_url(@realisasi), notice: "Realisasi was successfully created." }
        format.json { render :show, status: :created, location: @realisasi }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @realisasi.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /realisasis/1 or /realisasis/1.json
  def update
    respond_to do |format|
      if @realisasi.update(realisasi_params)
        format.html { redirect_to realisasi_url(@realisasi), notice: "Realisasi was successfully updated." }
        format.json { render :show, status: :ok, location: @realisasi }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @realisasi.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /realisasis/1 or /realisasis/1.json
  def destroy
    @realisasi.destroy

    respond_to do |format|
      format.html { redirect_to realisasis_url, notice: "Realisasi was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_realisasi
    @realisasi = Realisasi.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def realisasi_params
    params.require(:realisasi).permit(:tahun, :realisasi, :satuan, :jenis, :target_id)
  end
end
