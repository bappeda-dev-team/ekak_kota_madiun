class IndikatorsController < ApplicationController
  before_action :set_indikator, only: %i[show edit update destroy]

  def rkpd
    @tahun = cookies[:tahun]
    @kode_opd = cookies[:opd]

    @tahun_bener = @tahun.match(/murni|perubahan/) ? @tahun[/[^_]\d*/, 0] : @tahun

    @opd = Opd.find_by(kode_unik_opd: @kode_opd)
    @nama_opd = @opd.nama_opd
    @tujuan_opds = @opd.tujuan_opds
                       .by_periode(@tahun_bener)
  end

  # GET /indikators or /indikators.json
  def index
    @indikators = Indikator.all
  end

  # GET /indikators/1 or /indikators/1.json
  def show; end

  # GET /indikators/new
  def new
    @indikator = Indikator.new
  end

  # GET /indikators/1/edit
  def edit; end

  # POST /indikators or /indikators.json
  def create
    @indikator = Indikator.new(indikator_params)

    respond_to do |format|
      if @indikator.save
        format.html { redirect_to indikator_url(@indikator), notice: "Indikator was successfully created." }
        format.json { render :show, status: :created, location: @indikator }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @indikator.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /indikators/1 or /indikators/1.json
  def update
    respond_to do |format|
      if @indikator.update(indikator_params)
        format.html { redirect_to indikator_url(@indikator), notice: "Indikator was successfully updated." }
        format.json { render :show, status: :ok, location: @indikator }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @indikator.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /indikators/1 or /indikators/1.json
  def destroy
    @indikator.destroy

    respond_to do |format|
      format.html { redirect_to indikators_url, notice: "Indikator was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_indikator
    @indikator = Indikator.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def indikator_params
    params.fetch(:indikator, {})
  end
end
