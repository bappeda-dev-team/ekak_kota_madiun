class KemungkinansController < ApplicationController
  before_action :set_kemungkinan, only: %i[show edit update destroy]

  # GET /kemungkinans or /kemungkinans.json
  def index
    @kemungkinans = Kemungkinan.all
  end

  # GET /kemungkinans/1 or /kemungkinans/1.json
  def show; end

  # GET /kemungkinans/new
  def new
    @kemungkinan = Kemungkinan.new
  end

  # GET /kemungkinans/1/edit
  def edit; end

  # POST /kemungkinans or /kemungkinans.json
  def create
    @kemungkinan = Kemungkinan.new(kemungkinan_params)

    respond_to do |format|
      if @kemungkinan.save
        format.html { redirect_to kemungkinan_url(@kemungkinan), notice: "Kemungkinan was successfully created." }
        format.json { render :show, status: :created, location: @kemungkinan }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @kemungkinan.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /kemungkinans/1 or /kemungkinans/1.json
  def update
    respond_to do |format|
      if @kemungkinan.update(kemungkinan_params)
        format.html { redirect_to kemungkinan_url(@kemungkinan), notice: "Kemungkinan was successfully updated." }
        format.json { render :show, status: :ok, location: @kemungkinan }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @kemungkinan.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /kemungkinans/1 or /kemungkinans/1.json
  def destroy
    @kemungkinan.destroy

    respond_to do |format|
      format.html { redirect_to kemungkinans_url, notice: "Kemungkinan was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_kemungkinan
    @kemungkinan = Kemungkinan.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def kemungkinan_params
    params.fetch(:kemungkinan).permit(:deskripsi, :keterangan, :kode_skala, :nilai, :tipe_nilai, :type)
  end
end
