class PokpirsController < ApplicationController
  before_action :set_pokpir, only: %i[show edit update destroy aktifkan_pokpir non_aktifkan_pokpir diambil_asn]
  layout false, only: %i[new edit]

  # GET /pokpirs or /pokpirs.json
  def index
    tahun = cookies[:tahun] || Date.current.year.to_s
    @tahun_bener = tahun.match(/murni|perubahan/) ? tahun[/[^_]\d*/, 0] : tahun
    @pokpirs = Pokpir.where(tahun: @tahun_bener).order(:updated_at).select do |m|
      m.opd_dituju&.id_opd_skp == current_user.opd.id_opd_skp or current_user.has_role? :super_admin or m.opd == current_user.opd.kode_unik_opd
    end
  end

  def usulan_pokpir
    tahun = cookies[:tahun] || Date.current.year.to_s
    @tahun_bener = tahun.match(/murni|perubahan/) ? tahun[/[^_]\d*/, 0] : tahun
    @pokpirs = Pokpir.where(tahun: @tahun_bener).order(:updated_at).select do |m|
      m.opd_dituju&.id_opd_skp == current_user.opd.id_opd_skp or current_user.has_role? :super_admin or m.opd == current_user.opd.kode_unik_opd
    end
    render 'user_pokpir'
  end

  def diambil_asn
    @pokpir = Pokpir.find(params[:id])
    @status = 'aktif'
    @nip_asn = params[:nip_asn]
    if @pokpir.update(nip_asn: @nip_asn, status: @status)
      @pokpir.toggle! :is_active
      flash.now[:success] = 'Usulan berhasil diambil'
    else
      flash.now[:error] = 'Usulan gagal diambil'
      :unprocessable_entity
    end
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
    @pokpir = Pokpir.find(params[:id])
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
    @pokpir.map do |m|
      m.update(opd: m.kamus_usulans.first.id_unit)
      m.update(usulan: m.kamus_usulans.first.usulan)
    end
    flash[:success] = 'Usulan disesuaikan dengan kamus'
    redirect_to pokpirs_path
  end

  def pokpir_search
    tahun = cookies[:tahun] || Date.current.year.to_s
    tahun_bener = tahun.match(/murni|perubahan/) ? tahun[/[^_]\d*/, 0] : tahun
    param = params[:q] || ''
    @pokpirs = Search::AllUsulan
               .where(
                 "searchable_type = 'Pokpir' and sasaran_id is null and usulan ILIKE ?", "%#{param}%"
               )
               .where(searchable: Pokpir.where(nip_asn: current_user.nik, tahun: tahun_bener))
               .order(searchable_id: :desc)
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
    is_admin_kota = current_user.admin_kota?
    user = is_admin_kota ? '' : current_user.nik
    tahun = cookies[:tahun] || Date.current.year.to_s
    @kode_opd = is_admin_kota ? params[:opd] : cookies[:opd]
    @pokpir = Pokpir.new(tahun: tahun, status: 'aktif', nip_asn: user,
                         is_active: is_admin_kota)
  end

  # GET /pokpirs/1/edit
  def edit
    @kode_opd = @pokpir.opd
  end

  # POST /pokpirs or /pokpirs.json
  def create
    @pokpir = Pokpir.new(pokpir_params)

    if @pokpir.save
      render json: { resText: "Entri Pokok Pikiran ditambahkan",
                     html_content: html_content({ pokpir: @pokpir },
                                                partial: 'pokpirs/pokpir') }.to_json,
             status: :ok
    else
      render json: { resText: "Terjadi kesalahan",
                     html_content: error_content({ pokpir: @pokpir },
                                                 partial: 'pokpirs/form') }.to_json,
             status: :unprocessable_entity
    end
  end

  # PATCH/PUT /pokpirs/1 or /pokpirs/1.json
  def update
    if @pokpir.update(pokpir_params)
      render json: { resText: "Perubahan tersimpan",
                     html_content: html_content({ pokpir: @pokpir },
                                                partial: 'pokpirs/pokpir') }.to_json,
             status: :ok
    else
      render json: { resText: "Terjadi kesalahan",
                     html_content: error_content({ pokpir: @pokpir },
                                                 partial: 'pokpirs/form') }.to_json,
             status: :unprocessable_entity
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
