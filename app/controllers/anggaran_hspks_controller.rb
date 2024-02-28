class AnggaranHspksController < ApplicationController
  before_action :set_anggaran_hspk, only: %i[show edit update destroy]
  layout false, only: %i[new edit]

  # GET /anggaran_hspks or /anggaran_hspks.json
  def index
    @anggaran_hspks = if current_user.id == 1
                        AnggaranHspk.all.limit(50)
                      else
                        AnggaranHspk.where(opd_id: current_user.opd.id)
                      end
  end

  def anggaran_hspk_search
    param = params[:q] || ''
    @anggaran_hspks = AnggaranHspk.where('uraian_barang ILIKE ?',
                                         "%#{param}%")
                                  .or(AnggaranHspk.where('spesifikasi ILIKE ?', "%#{param}%"))
                                  .limit(80)
  end

  # GET /anggaran_hspks/1 or /anggaran_hspks/1.json
  def show; end

  # GET /anggaran_hspks/new
  def new
    @anggaran_hspk = AnggaranHspk.new
  end

  # GET /anggaran_hspks/1/edit
  def edit; end

  # POST /anggaran_hspks or /anggaran_hspks.json
  def create
    @anggaran_hspk = AnggaranHspk.new(anggaran_hspk_params)

    respond_to do |format|
      if @anggaran_hspk.save
        format.html { redirect_to anggaran_hspks_path, notice: "Anggaran hspk was successfully created." }
        format.json { render :show, status: :created, location: @anggaran_hspk }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @anggaran_hspk.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /anggaran_hspks/1 or /anggaran_hspks/1.json
  def update
    respond_to do |format|
      if @anggaran_hspk.update(anggaran_hspk_params)
        format.html { redirect_to anggaran_hspks_path, notice: "Anggaran hspk was successfully updated." }
        format.json { render :show, status: :ok, location: @anggaran_hspk }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @anggaran_hspk.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /anggaran_hspks/1 or /anggaran_hspks/1.json
  def destroy
    @anggaran_hspk.destroy
    respond_to do |format|
      format.html { redirect_to anggaran_hspks_url, notice: "Anggaran hspk was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_anggaran_hspk
    @anggaran_hspk = AnggaranHspk.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def anggaran_hspk_params
    params.require(:anggaran_hspk).permit(:kode_kelompok_barang, :uraian_kelompok_barang, :kode_barang,
                                          :tahun, :id_standar_harga, :opd_id,
                                          :uraian_barang, :spesifikasi, :satuan, :harga_satuan)
  end
end
