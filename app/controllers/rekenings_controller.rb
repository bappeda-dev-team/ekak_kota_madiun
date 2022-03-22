class RekeningsController < ApplicationController
  before_action :set_rekening, only: %i[show edit update destroy]

  # GET /rekenings or /rekenings.json
  def index
    @rekenings = Rekening.all
  end

  def rekening_search
    param = params[:q] || ''
    @rekenings = Rekening.where(set_input: 1).where('jenis_rekening ILIKE ?', "%#{param}%").limit(50)
  end

  # GET /rekenings/1 or /rekenings/1.json
  def show; end

  # GET /rekenings/new
  def new
    @rekening = Rekening.new
  end

  # GET /rekenings/1/edit
  def edit; end

  # POST /rekenings or /rekenings.json
  def create
    @rekening = Rekening.new(rekening_params)

    respond_to do |format|
      if @rekening.save
        format.html { redirect_to @rekening, notice: 'Rekening was successfully created.' }
        format.json { render :show, status: :created, location: @rekening }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @rekening.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rekenings/1 or /rekenings/1.json
  def update
    respond_to do |format|
      if @rekening.update(rekening_params)
        format.html { redirect_to @rekening, notice: 'Rekening was successfully updated.' }
        format.json { render :show, status: :ok, location: @rekening }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @rekening.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rekenings/1 or /rekenings/1.json
  def destroy
    @rekening.destroy
    respond_to do |format|
      format.html { redirect_to rekenings_url, notice: 'Rekening was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_rekening
    @rekening = Rekening.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def rekening_params
    params.require(:rekening).permit(:kode_rekening, :jenis_rekening, :set_input)
  end
end
