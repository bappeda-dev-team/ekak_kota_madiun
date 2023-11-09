class StrategiArahKebijakansController < ApplicationController
  before_action :set_strategi_arah_kebijakan, only: %i[show edit update destroy]

  # GET /strategi_arah_kebijakans or /strategi_arah_kebijakans.json
  def index
    @strategi_arah_kebijakans = StrategiArahKebijakan.all
  end

  def kota
    @strategi_arah_kebijakans = StrategiArahKebijakan.all
  end

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

  # GET /strategi_arah_kebijakans/1 or /strategi_arah_kebijakans/1.json
  def show; end

  # GET /strategi_arah_kebijakans/new
  def new
    @strategi_arah_kebijakan = StrategiArahKebijakan.new
  end

  # GET /strategi_arah_kebijakans/1/edit
  def edit; end

  # POST /strategi_arah_kebijakans or /strategi_arah_kebijakans.json
  def create
    @strategi_arah_kebijakan = StrategiArahKebijakan.new(strategi_arah_kebijakan_params)

    respond_to do |format|
      if @strategi_arah_kebijakan.save
        format.html do
          redirect_to strategi_arah_kebijakan_url(@strategi_arah_kebijakan),
                      notice: "Strategi arah kebijakan was successfully created."
        end
        format.json { render :show, status: :created, location: @strategi_arah_kebijakan }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @strategi_arah_kebijakan.errors, status: :unprocessable_entity }
      end
    end
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

  # DELETE /strategi_arah_kebijakans/1 or /strategi_arah_kebijakans/1.json
  def destroy
    @strategi_arah_kebijakan.destroy

    respond_to do |format|
      format.html do
        redirect_to strategi_arah_kebijakans_url, notice: "Strategi arah kebijakan was successfully destroyed."
      end
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_strategi_arah_kebijakan
    @strategi_arah_kebijakan = StrategiArahKebijakan.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def strategi_arah_kebijakan_params
    params.fetch(:strategi_arah_kebijakan, {})
  end
end
