class InovasisController < ApplicationController
  before_action :set_inovasi, only: %i[show edit update destroy]

  # GET /inovasis or /inovasis.json
  def index
    @inovasis = Inovasi.all
  end

  def usulan_inisiatif
    @inovasis = Inovasi.all.order(:created_at)
    render 'index'
  end

  # GET /inovasis/1 or /inovasis/1.json
  def show; end

  # GET /inovasis/new
  def new
    @inovasi = Inovasi.new
  end

  # GET /inovasis/1/edit
  def edit; end

  # POST /inovasis or /inovasis.json
  def create
    @inovasi = Inovasi.new(inovasi_params)

    respond_to do |format|
      if @inovasi.save
        format.js
        format.html { redirect_to @inovasi, notice: 'Inovasi was successfully created.' }
        format.json { render :show, status: :created, location: @inovasi }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @inovasi.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /inovasis/1 or /inovasis/1.json
  def update
    respond_to do |format|
      if @inovasi.update(inovasi_params)
        format.js
        format.html { redirect_to @inovasi, notice: 'Inovasi was successfully updated.' }
        format.json { render :show, status: :ok, location: @inovasi }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @inovasi.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /inovasis/1 or /inovasis/1.json
  def destroy
    @inovasi.destroy
    respond_to do |format|
      format.html { redirect_to inovasis_url, notice: 'Inovasi was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_inovasi
    @inovasi = Inovasi.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def inovasi_params
    params.require(:inovasi).permit(:usulan, :manfaat, :nip_asn, :tahun, :sasaran_id)
  end
end
