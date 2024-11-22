class MitrasController < ApplicationController
  before_action :set_mitra, only: %i[show edit update destroy]
  layout false

  # GET /mitras or /mitras.json
  def index
    @mitras = Mitra.all
  end

  # GET /mitras/1 or /mitras/1.json
  def show; end

  # GET /mitras/new
  def new
    @mitra = Mitra.new
  end

  def new_internal
    render partial: 'mitra_internal_fields'
  end

  def new_external_pemerintah
    render partial: 'mitra_external_pemerintah_fields'
  end

  # GET /mitras/1/edit
  def edit; end

  # POST /mitras or /mitras.json
  def create
    @mitra = Mitra.new(mitra_params)

    respond_to do |format|
      if @mitra.save
        format.html { redirect_to mitra_url(@mitra), notice: "Mitra was successfully created." }
        format.json { render :show, status: :created, location: @mitra }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @mitra.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /mitras/1 or /mitras/1.json
  def update
    respond_to do |format|
      if @mitra.update(mitra_params)
        format.html { redirect_to mitra_url(@mitra), notice: "Mitra was successfully updated." }
        format.json { render :show, status: :ok, location: @mitra }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @mitra.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /mitras/1 or /mitras/1.json
  def destroy
    @mitra.destroy

    respond_to do |format|
      format.html { redirect_to mitras_url, notice: "Mitra was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_mitra
    @mitra = Mitra.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def mitra_params
    params.require(:mitra).permit(:jenis_mitra, :nama_kerjasama, :penjelasan_kerjasama, :tahun_kerjasama,
                                  :keterangan, :crosscutting_id)
  end
end
