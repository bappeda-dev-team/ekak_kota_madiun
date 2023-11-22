class PindahPohonKinerjasController < ApplicationController
  before_action :set_pindah_pohon_kinerja, only: %i[show edit update destroy]
  layout false

  # GET /pindah_pohon_kinerjas or /pindah_pohon_kinerjas.json
  def index; end

  # GET /pindah_pohon_kinerjas/1 or /pindah_pohon_kinerjas/1.json
  def show; end

  # GET /pindah_pohon_kinerjas/1/edit
  def edit
    @role_atasan = params[:role_atasan]
    @list_atasan = Strategi.where(opd_id: @pindah_pohon_kinerja.opd_id,
                                  tahun: @pindah_pohon_kinerja.tahun,
                                  role: @role_atasan)
  end

  # PATCH/PUT /pindah_pohon_kinerjas/1 or /pindah_pohon_kinerjas/1.json
  def update
    respond_to do |format|
      if @pindah_pohon_kinerja.update(pindah_pohon_kinerja_params)
        format.html do
          redirect_to cascading_pohon_kinerja_opds_url,
                      success: "Pindah pohon berhasil"
        end
        format.json { render :show, status: :ok, location: @pindah_pohon_kinerja }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @pindah_pohon_kinerja.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pindah_pohon_kinerjas/1 or /pindah_pohon_kinerjas/1.json
  def destroy
    @pindah_pohon_kinerja.destroy

    respond_to do |format|
      format.html { redirect_to pindah_pohon_kinerjas_url, notice: "Pindah pohon kinerja was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_pindah_pohon_kinerja
    @pindah_pohon_kinerja = Strategi.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def pindah_pohon_kinerja_params
    params.fetch(:strategi_pohon, {}).permit(:strategi_ref_id)
  end
end
