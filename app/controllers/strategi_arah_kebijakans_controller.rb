class StrategiArahKebijakansController < ApplicationController
  # before_action :set_strategi_arah_kebijakan, only: %i[show edit update destroy]

  def opd
    @tahun = cookies[:tahun]
    @kode_opd = cookies[:opd]
    strategi_arah_kebijakan = StrategiArahKebijakan.new(tahun: @tahun, kode_opd: @kode_opd)
    @opd = strategi_arah_kebijakan.opd
    @isu_strategis_opds = strategi_arah_kebijakan.isu_strategis_opds
    @tujuan_opds = strategi_arah_kebijakan.tujuan_opds
    @strategi_opds = strategi_arah_kebijakan.strategi_opds
    @tactical_opds = strategi_arah_kebijakan.tactical_opds
  end

  # PATCH/PUT /strategi_arah_kebijakans/1 or /strategi_arah_kebijakans/1.json
  def update
    respond_to do |format|
      if @strategi_arah_kebijakan.update(strategi_arah_kebijakan_params)
        format.html do
          redirect_to strategi_arah_kebijakan_url(@strategi_arah_kebijakan),
                      notice: "Strategi arah kebijakan was successfully updated."
        end
        format.json { render :show, status: :ok, location: @strategi_arah_kebijakan }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @strategi_arah_kebijakan.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_strategi
    @strategi = Strategi.find(params[:strategi_id])
  end

  # Only allow a list of trusted parameters through.
  def strategi_arah_kebijakan_params
    params.fetch(:strategi_arah_kebijakan, {})
  end
end
