class MandatorisController < ApplicationController
  before_action :set_mandatori, only: %i[show edit update destroy]

  # GET /mandatoris or /mandatoris.json
  def index
    kode_opd = Opd.find_by(kode_unik_opd: cookies[:opd]).kode_opd
    @mandatoris = Mandatori.includes(:user).where(user: { kode_opd: kode_opd })
  end

  # TODO: refactor, violating rails principle
  def usulan_mandatori
    @mandatoris = Mandatori.where(nip_asn: current_user.nik).order(:created_at)
    render 'user_mandatori'
  end

  def spbe
    tahun = cookies[:tahun]
    @mandatoris = SasaranSpbe.all
  end

  # GET /mandatoris/1 or /mandatoris/1.json
  def show; end

  # GET /mandatoris/new
  def new
    user = current_user.nik
    opd = Opd.find_by_kode_unik_opd cookies[:opd]
    tahun = cookies[:tahun]
    @mandatori = Mandatori.new(tahun: tahun, nip_asn: user, opd: opd)
    render layout: false
  end

  # GET /mandatoris/1/edit
  def edit; end

  # POST /mandatoris or /mandatoris.json
  def create
    @mandatori = Mandatori.new(mandatori_params)

    respond_to do |format|
      if @mandatori.save
        format.js
        format.html { redirect_to usulan_mandatori_path, notice: 'Usulan mandatori berhasil dibuat' }
        format.json { render :show, status: :created, location: @mandatori }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @mandatori.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /mandatoris/1 or /mandatoris/1.json
  def update
    respond_to do |format|
      if @mandatori.update(mandatori_params)
        format.js
        format.html { redirect_to usulan_mandatori_path, notice: 'Usulan mandatori berhasil diperbarui' }
        format.json { render :show, status: :ok, location: @mandatori }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @mandatori.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /mandatoris/1 or /mandatoris/1.json
  def destroy
    @mandatori.destroy
    respond_to do |format|
      format.html { redirect_to usulan_mandatori_path, notice: 'Usulan dihapus' }
      format.json { head :no_content }
    end
  end

  def toggle_is_active
    @mandatori = Mandatori.find(params[:id])
    respond_to do |format|
      if @mandatori.update(status: 'disetujui')
        @mandatori.toggle! :is_active
        flash.now[:success] = 'Usulan diaktifkan'
        format.js { render 'toggle_is_active' }
      else
        flash.now[:alert] = 'Gagal Mengaktifkan'
        format.js { :unprocessable_entity }
      end
    end
  end

  def setujui_usulan_di_sasaran
    @mandatori = Mandatori.find(params[:id])
    respond_to do |format|
      if @mandatori.update(status: 'disetujui')
        @mandatori.toggle! :is_active
        flash.now[:success] = 'Usulan disetujui'
        format.js { render 'toggle_is_active' }
      else
        flash.now[:alert] = 'Gagal Mengaktifkan'
        format.js { :unprocessable_entity }
      end
    end
  end

  def mandatori_search
    param = params[:q] || ''
    @mandatoris = Search::AllUsulan
                  .where(
                    "searchable_type = 'Mandatori' and sasaran_id is null and usulan ILIKE ?", "%#{param}%"
                  )
                  .where(searchable: Mandatori.where(nip_asn: current_user.nik))
                  .includes(:searchable)
                  .collect(&:searchable)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_mandatori
    @mandatori = Mandatori.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def mandatori_params
    params.require(:mandatori).permit!
  end
end
