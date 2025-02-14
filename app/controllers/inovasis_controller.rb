class InovasisController < ApplicationController
  before_action :set_inovasi, only: %i[show edit update destroy]

  # GET /inovasis or /inovasis.json
  def index
    list_inovasis
  end

  def usulan_inisiatif
    list_inovasis
    nip_pemilik = current_user.nik
    @inovasis = @inovasis.where(nip_asn: [nip_pemilik, ''])
    render 'user_inisiatif'
  end

  # GET /inovasis/1 or /inovasis/1.json
  def show; end

  # GET /inovasis/new
  def new
    user = current_user.admin? ? '' : current_user.nik
    @opd = cookies[:opd]
    tahun = cookies[:tahun]
    @opds = Opd.opd_resmi_kota
               .pluck(:nama_opd,
                      :kode_unik_opd)
    @inovasi = Inovasi.new(tahun: tahun, status: 'draft', nip_asn: user)
    render layout: false
  end

  # GET /inovasis/1/edit
  def edit
    render layout: false
  end

  # POST /inovasis or /inovasis.json
  def create
    # form_params = inovasi_params.merge(is_active: true, status: 'disetujui')
    @inovasi = Inovasi.new(inovasi_params)

    if @inovasi.save
      render json: { resText: "Entri Inisiatif ditambahkan",
                     html_content: html_content({ inovasi: @inovasi },
                                                partial: 'inovasis/inovasi') }.to_json,
             status: :ok
    else
      render json: { resText: "Terjadi kesalahan",
                     html_content: error_content({ inovasi: @inovasi },
                                                 partial: 'inovasis/form') }.to_json,
             status: :unprocessable_entity
    end
  end

  # PATCH/PUT /inovasis/1 or /inovasis/1.json
  def update
    if @inovasi.update(inovasi_params)
      render json: { resText: "Perubahan tersimpan",
                     html_content: html_content({ inovasi: @inovasi },
                                                partial: 'inovasis/inovasi') }.to_json,
             status: :ok
    else
      render json: { resText: "Terjadi kesalahan",
                     html_content: error_content({ inovasi: @inovasi },
                                                 partial: 'inovasis/form') }.to_json,
             status: :unprocessable_entity
    end
  end

  # DELETE /inovasis/1 or /inovasis/1.json
  def destroy
    @inovasi.destroy
    render json: { resText: "Usulan inisiatif Dihapus", result: true }
  end

  def toggle_is_active
    @inovasi = Inovasi.find(params[:id])
    respond_to do |format|
      if @inovasi.update(status: 'disetujui')
        @inovasi.toggle! :is_active
        flash.now[:success] = 'Usulan diaktifkan'
        format.js { render 'toggle_is_active' }
      else
        flash.now[:alert] = 'Gagal Mengaktifkan'
        format.js { :unprocessable_entity }
      end
    end
  end

  def setujui_usulan_di_sasaran
    @inovasi = Inovasi.find(params[:id])
    respond_to do |format|
      if @inovasi.update(status: 'disetujui')
        @inovasi.toggle! :is_active
        flash.now[:success] = 'Usulan disetujui'
        format.js { render 'toggle_is_active' }
      else
        flash.now[:alert] = 'Gagal Mengaktifkan'
        format.js { :unprocessable_entity }
      end
    end
  end

  def inovasi_search
    tahun = cookies[:tahun] || Date.current.year.to_s
    param = params[:q] || ''
    @inovasis = Search::AllUsulan
                .where(
                  "searchable_type = 'Inovasi' and sasaran_id is null and usulan ILIKE ?", "%#{param}%"
                )
                .where(searchable: Inovasi.where(nip_asn: current_user.nik, tahun: tahun))
                .order(searchable_id: :desc)
                .includes(:searchable)
                .collect(&:searchable)
  end

  def diambil_asn
    @inovasi = Inovasi.find(params[:id])
    @status = 'aktif'
    @nip_asn = params[:nip_asn]
    if @inovasi.update(nip_asn: @nip_asn, status: @status)
      @inovasi.toggle! :is_active
      flash.now[:success] = 'Usulan berhasil diambil'
    else
      flash.now[:error] = 'Usulan gagal diambil'
      :unprocessable_entity
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_inovasi
    @inovasi = Inovasi.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def inovasi_params
    params.require(:inovasi).permit!
  end

  def list_inovasis
    @tahun = cookies[:tahun] || Date.current.year.to_s
    @kode_opd = cookies[:opd]
    @opd = Opd.find_by(kode_unik_opd: @kode_opd)
    @inovasis = Inovasi.includes(:user)
                       .where(tahun: @tahun)
                       .where("opd = ? OR users.kode_opd = ?", @opd.kode_unik_opd, @opd.kode_opd)
                       .references(:user)
  end
end
