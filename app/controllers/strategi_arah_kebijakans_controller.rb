class StrategiArahKebijakansController < ApplicationController
  before_action :set_strategi_arah_kebijakan, only: %i[edit update]
  layout false, only: %i[new edit]

  def opd
    @tahun = cookies[:tahun]
    @kode_opd = cookies[:opd]
    strategi_arah_kebijakan = StrategiArahKebijakan.new(tahun: @tahun, kode_opd: @kode_opd)
    @opd = strategi_arah_kebijakan.opd
    @isu_strategis_opds = strategi_arah_kebijakan.isu_strategis_opds
    @tujuan_opds = strategi_arah_kebijakan.tujuan_opds
    @strategi_opds = strategi_arah_kebijakan.tujuan_strategi_opds
    @tactical_opds = strategi_arah_kebijakan.tactical_opds
  end

  def edit
    @strategi_opds = @strategi_arah_kebijakan.strategi_opds
  end

  # PATCH/PUT /strategi_arah_kebijakans/1 or /strategi_arah_kebijakans/1.json
  def update
    check = params[:check]
    strategis = Strategi.where(id: check)

    binding.pry

    strategis.update_all(
      tujuan_id: @tujuan.id
    )

    binding.pry

    @strategi_opds = @strategi_arah_kebijakan.tujuan_strategi_opds
    @tactical_opds = @strategi_arah_kebijakan.tactical_opds
    if strategis.any?
      render json: { resText: "",
                     html_content: html_content({ },
                     partial: 'strategi_arah_kebijakans/table_kebijakans') }.to_json,
             status: :ok
    else
      render json: { resText: "Tidak ada perubahan" }.to_json,
             status: :not_modified
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_strategi_arah_kebijakan
    @tahun = cookies[:tahun]
    @kode_opd = cookies[:opd]
    @tujuan = TujuanOpd.find(params[:id])
    @strategi_arah_kebijakan = StrategiArahKebijakan.new(tahun: @tahun, kode_opd: @kode_opd)
  end

  # Only allow a list of trusted parameters through.
  def strategi_arah_kebijakan_params
    params.fetch(:strategi_arah_kebijakan, {})
  end
end
