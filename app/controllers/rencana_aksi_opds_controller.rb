class RencanaAksiOpdsController < ApplicationController
  before_action :set_rencana_aksi_opd, only: %i[show edit update destroy]
  layout false, only: %i[new edit]

  # GET /rencana_aksi_opds or /rencana_aksi_opds.json
  def index
    @tahun = cookies[:tahun]
    @kode_opd = cookies[:opd]
    @opd = Opd.find_by(kode_unik_opd: @kode_opd)
    @sasaran_opds = @opd.strategi_eselon2.flat_map { |st| st.sasaran_pohon_kinerja(tahun: @tahun) }
    # @rencana_aksi_opds = RencanaAksiOpd.all
  end

  # GET /rencana_aksi_opds/1 or /rencana_aksi_opds/1.json
  def show; end

  # GET /rencana_aksi_opds/new
  def new
    @tahun = params[:tahun]
    @kode_opd = params[:kode_opd]
    @sasaran_opd_id = params[:sasaran_id]
    @sasaran = Sasaran.find(@sasaran_opd_id)

    @rencana_aksi_opd = RencanaAksiOpd.new(tahun: @tahun,
                                           kode_opd: @kode_opd,
                                           sasaran_id: @sasaran_opd_id)
  end

  # GET /rencana_aksi_opds/1/edit
  def edit; end

  # POST /rencana_aksi_opds or /rencana_aksi_opds.json
  def create
    @rencana_aksi_opd = RencanaAksiOpd.new(rencana_aksi_opd_params)
    @sasaran_opd = Sasaran.find(rencana_aksi_opd_params[:sasaran_id])
    i = 1

    if @rencana_aksi_opd.save
      render json: { resText: 'Renaksi OPD ditambahkan',
                     html_content: html_content({ sasaran: @sasaran_opd, i: i },
                                                partial: 'rencana_aksi_opds/row_rencana_aksi_opd') }
        .to_json,
             status: :ok
    else
      render json: { resText: 'Terjadi kesalahan',
                     html_content: html_content({ rencana_aksi_opd: @rencana_aksi_opd },
                                                partial: 'rencana_aksi_opds/form') }
        .to_json,
             status: :unprocessable_entity
    end
  end

  # PATCH/PUT /rencana_aksi_opds/1 or /rencana_aksi_opds/1.json
  def update
    respond_to do |format|
      if @rencana_aksi_opd.update(rencana_aksi_opd_params)
        format.html do
          redirect_to rencana_aksi_opd_url(@rencana_aksi_opd), notice: "Rencana aksi opd was successfully updated."
        end
        format.json { render :show, status: :ok, location: @rencana_aksi_opd }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @rencana_aksi_opd.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rencana_aksi_opds/1 or /rencana_aksi_opds/1.json
  def destroy
    @rencana_aksi_opd.destroy

    respond_to do |format|
      format.html { redirect_to rencana_aksi_opds_url, notice: "Rencana aksi opd was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_rencana_aksi_opd
    @rencana_aksi_opd = RencanaAksiOpd.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def rencana_aksi_opd_params
    params.require(:rencana_aksi_opd).permit(:tw1, :tw2, :tw3, :tw4, :is_hidden, :tahun, :kode_opd,
                                             :id_rencana_renaksi, :sasaran_id)
  end
end
