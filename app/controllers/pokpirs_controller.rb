class PokpirsController < ApplicationController
  before_action :set_pokpir, only: %i[show edit update destroy aktifkan_pokpir non_aktifkan_pokpir diambil_asn]

  # GET /pokpirs or /pokpirs.json
  def index
    @pokpirs = Pokpir.all
  end

  def toggle_is_active
    @pokpir = Pokpir.find(params[:id])
    respond_to do |format|
      if @pokpir.update(status: 'aktif')
        @pokpir.toggle! :is_active
        flash.now[:success] = 'Usulan diaktifkan'
        format.js { render 'toggle_is_active' }
      else
        flash.now[:alert] = 'Gagal Mengaktifkan'
        format.js { :unprocessable_entity }
      end
    end
  end

  def setujui_usulan_di_sasaran
    @pokpir = Musrenbang.find(params[:id])
    respond_to do |format|
      if @pokpir.update(status: 'disetujui')
        @pokpir.toggle! :is_active
        flash.now[:success] = 'Usulan disetujui'
        format.js { render 'toggle_is_active' }
      else
        flash.now[:alert] = 'Gagal Mengaktifkan'
        format.js { :unprocessable_entity }
      end
    end
  end

  def update_opd
    @pokpir = Pokpir.with_kamus
    @pokpir.map { |m| m.update(opd: m.kamus_usulans.first.id_unit) }
    flash[:success] = 'Usulan disesuaikan dengan kamus'
    redirect_to pokpirs_path
  end

  def usulan_pokpir
    @pokpirs = Pokpir.all.order(:created_at)
    render 'user_pokpir'
  end

  def diambil_asn
    @pokpir = Pokpir.find(params[:id])
    @status = params[:status]
    @nip_asn = params[:nip_asn]
    if @pokpir.update(nip_asn: @nip_asn, status: @status)
      flash.now[:success] = 'Usulan berhasil diambil'
    else
      flash.now[:error] = 'Usulan gagal diambil'
      :unprocessable_entity
    end
  end

  def pokpir_search
    param = params[:q] || ''
    @pokpirs = Search::AllUsulan
               .where(
                 "searchable_type = 'Pokpir' and sasaran_id is null and usulan ILIKE ?", "%#{param}%"
               )
               .where(searchable: Pokpir.where(nip_asn: current_user.nik))
               .includes(:searchable)
               .collect(&:searchable)
  end

  # GET /pokpirs/1 or /pokpirs/1.json
  def show; end

  def aktifkan_pokpir
    respond_to do |format|
      format.js { render :aktifkan_pokpir } if @pokpir.update_attribute(:is_active, 1)
    end
  end

  def non_aktifkan_pokpir
    respond_to do |format|
      format.js { render :non_aktifkan_pokpir } if @pokpir.update_attribute(:is_active, 0)
    end
  end

  # GET /pokpirs/new
  def new
    @pokpir = Pokpir.new
  end

  # GET /pokpirs/1/edit
  def edit; end

  # POST /pokpirs or /pokpirs.json
  def create
    @pokpir = Pokpir.new(pokpir_params)

    respond_to do |format|
      if @pokpir.save
        format.js
        format.html { redirect_to pokpirs_path, notice: 'Pokpir was successfully created.' }
        format.json { render :show, status: :created, location: @pokpir }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @pokpir.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pokpirs/1 or /pokpirs/1.json
  def update
    respond_to do |format|
      if @pokpir.update(pokpir_params)
        format.js
        format.html { redirect_to @pokpir, notice: 'Pokpir was successfully updated.' }
        format.json { render :show, status: :ok, location: @pokpir }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @pokpir.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pokpirs/1 or /pokpirs/1.json
  def destroy
    @pokpir.destroy
    respond_to do |format|
      format.html { redirect_to pokpirs_url, notice: 'Pokpir was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_pokpir
    @pokpir = Pokpir.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def pokpir_params
    params.require(:pokpir).permit!
  end
end
