class InovasisController < ApplicationController
  before_action :set_inovasi, only: %i[show edit update destroy]

  # GET /inovasis or /inovasis.json
  def index
    kode_opd = Opd.find_by(kode_unik_opd: cookies[:opd]).kode_opd
    @inovasis = Inovasi.includes(:user).where(user: { kode_opd: kode_opd })
  end

  def usulan_inisiatif
    @inovasis = Inovasi.where(nip_asn: current_user.nik)
    render 'user_inisiatif'
  end

  # GET /inovasis/1 or /inovasis/1.json
  def show; end

  # GET /inovasis/new
  def new
    user = current_user.nik
    opd = Opd.find_by_kode_unik_opd(cookies[:opd])
    tahun = cookies[:tahun]
    @inovasi = Inovasi.new(tahun: tahun, nip_asn: user, opd: opd,
                           is_active: true, status: 'disetujui')
    render layout: false
  end

  # GET /inovasis/1/edit
  def edit
    render layout: false
  end

  # POST /inovasis or /inovasis.json
  def create
    @inovasi = Inovasi.new(inovasi_params)

    respond_to do |format|
      if @inovasi.save
        html_content = render_to_string(partial: 'inovasis/inovasi',
                                        formats: 'html',
                                        layout: false,
                                        locals: { inovasi: @inovasi })
        format.json do
          render json: { resText: "Inisiatif walikota tersimpan", attachmentPartial: html_content }.to_json,
                 status: :created
        end
      else
        error_content = render_to_string(partial: 'inovasis/form',
                                         formats: 'html',
                                         layout: false,
                                         locals: { inovasi: @inovasi })
        format.json do
          render json: { resText: "Gagal Menyimpan", errors: error_content }.to_json, status: :unprocessable_entity
        end
      end
    end
  end

  # PATCH/PUT /inovasis/1 or /inovasis/1.json
  def update
    respond_to do |format|
      if @inovasi.update(inovasi_params)
        html_content = render_to_string(partial: 'inovasis/inovasi',
                                        formats: 'html',
                                        layout: false,
                                        locals: { inovasi: @inovasi })
        format.json do
          render json: { resText: "Perubahan tersimpan", attachmentPartial: html_content, update: true }.to_json,
                 status: :ok
        end
      else
        error_content = render_to_string(partial: 'inovasis/form',
                                         formats: 'html',
                                         layout: false,
                                         locals: { inovasi: @inovasi })
        format.json do
          render json: { resText: "Gagal Menyimpan", errors: error_content }.to_json, status: :unprocessable_entity
        end
      end
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
    param = params[:q] || ''
    @inovasis = Search::AllUsulan
                .where(
                  "searchable_type = 'Inovasi' and sasaran_id is null and usulan ILIKE ?", "%#{param}%"
                )
                .where(searchable: Inovasi.where(nip_asn: current_user.nik))
                .includes(:searchable)
                .collect(&:searchable)
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
end
