class InovasisController < ApplicationController
  before_action :set_inovasi, only: %i[show edit update destroy]

  # GET /inovasis or /inovasis.json
  def index
    @tahun = cookies[:tahun] || Date.current.year.to_s
    is_admin_kota = current_user.admin_kota?
    @kode_opd = is_admin_kota ? "0.00.0.00.0.00.00.0000" : cookies[:opd]
    @opd = Opd.unscoped.find_by(kode_unik_opd: @kode_opd)

    @inovasis = if @opd.is_kota
                  Inovasi.includes(:misi, kolabs: [:opd]).where(tahun: @tahun)
                  # Inovasi.by_periode(@tahun_awal, @tahun_akhir)
                else
                  kode_opd = if @opd.setda?
                               @opd.all_kode_setda
                             else
                               [@kode_opd]
                             end
                  Inovasi.includes(:misi, kolabs: [:opd]).where(tahun: @tahun)
                         .select do |inovasi|
                    inovasi.opd.in?(kode_opd) ||
                      inovasi&.sasaran&.user&.opd&.kode_unik_opd == @kode_opd ||
                      inovasi.kolabs.any? do |kl|
                        kl.kode_unik_opd.in?(kode_opd)
                      end
                  end
                  # Inovasi.by_periode(@tahun_awal, @tahun_akhir)
                  #        .where(opd: @kode_opd)
                end
    # @inovasis = Inovasi.includes(:misi).where(tahun: @tahun)
  end

  def filter_opd_tahun
    @kode_opd = params[:opd]
    @opd = Opd.unscoped.find_by(kode_unik_opd: @kode_opd)
    @tahun = params[:tahun]

    # logic if periode
    # tahun_bener = @tahun.match(/murni|perubahan/) ? @tahun[/[^_]\d*/, 0] : @tahun
    # periode_selected = params[:periode]
    # @periode = if periode_selected.present?
    #              Periode.find(periode_selected)
    #            else
    #              Periode.find_tahun(tahun_bener)
    #            end
    # @tahun_awal = @periode.tahun_awal.to_i
    # @tahun_akhir = @periode.tahun_akhir.to_i

    @inovasis = if @opd.is_kota
                  Inovasi.includes(:misi, kolabs: [:opd]).where(tahun: @tahun)
                  # Inovasi.by_periode(@tahun_awal, @tahun_akhir)
                else
                  kode_opd = if @opd.setda?
                               @opd.all_kode_setda
                             else
                               [@kode_opd]
                             end
                  Inovasi.includes(:misi, kolabs: [:opd]).where(tahun: @tahun)
                         .select do |inovasi|
                    inovasi.opd.in?(kode_opd) ||
                      inovasi&.sasaran&.user&.opd&.kode_unik_opd == @kode_opd ||
                      inovasi.kolabs.any? do |kl|
                        kl.kode_unik_opd.in?(kode_opd)
                      end
                  end
                  # Inovasi.by_periode(@tahun_awal, @tahun_akhir)
                  #        .where(opd: @kode_opd)
                end
    # @inovasis = Inovasi.where(tahun: @tahun)

    render partial: 'inovasis/content_inovasi'
  end

  def usulan_inisiatif
    @tahun = cookies[:tahun] || Date.current.year.to_s
    @kode_opd = cookies[:opd]
    @opd = Opd.find_by(kode_unik_opd: @kode_opd)
    # nip_pemilik = current_user.nik
    # @inovasis = Inovasi.includes(%i[kolabs])
    #                    .where(
    #                      tahun: @tahun,
    #                      kolabs: { kode_unik_opd: @kode_opd }
    #                    )

    @inovasis = Inovasi.includes(:misi, :kolabs).where(tahun: @tahun)
                       .select do |inovasi|
      inovasi.opd == @kode_opd ||
        inovasi&.sasaran&.user&.opd&.kode_unik_opd == @kode_opd ||
        inovasi.kolabs.any? do |kl|
          kl.kode_unik_opd == @kode_opd
        end
    end
    render 'user_inisiatif'
  end

  # GET /inovasis/1 or /inovasis/1.json
  def show; end

  # GET /inovasis/new
  def new
    is_admin_kota = current_user.admin_kota?
    user = is_admin_kota ? '' : current_user.nik
    @kode_opd = is_admin_kota ? params[:opd] : cookies[:opd]
    # @opd = cookies[:opd]
    tahun = params[:tahun] || cookies[:tahun]
    # @opds = if is_admin_kota
    #           Opd.opd_resmi
    #              .pluck(:nama_opd,
    #                     :kode_unik_opd)
    #         else
    #           Opd.where(kode_opd: current_user.opd.kode_opd)
    #              .pluck(:nama_opd,
    #                     :kode_unik_opd)
    #         end
    @inovasi = Inovasi.new(tahun: tahun, status: 'aktif', nip_asn: user,
                           is_from_kota: is_admin_kota, is_active: is_admin_kota)
    render layout: false
  end

  # GET /inovasis/1/edit
  def edit
    # is_admin_kota = current_user.admin_kota?
    @kode_opd = @inovasi.opd
    # @opds = Opd.opd_resmi_kota
    #            .pluck(:nama_opd,
    #                   :kode_unik_opd)
    render layout: false
  end

  # POST /inovasis or /inovasis.json
  def create
    # form_params = inovasi_params.merge(is_active: true, status: 'disetujui')
    @inovasi = Inovasi.new(inovasi_params)
    @kode_opd = @inovasi.opd

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
    @kode_kota = "0.00.0.00.0.00.00.0000"
    @opd = Opd.unscoped.find_by(kode_unik_opd: @kode_opd)
    array_opd = [@opd.kode_unik_opd, @kode_kota]
    @inovasis = Inovasi.includes(:user)
                       .where(users: { kode_opd: @opd.kode_opd })
                       .or(Inovasi.where(opd: array_opd))
                       .where(tahun: @tahun)
                       .references(:user)
  end
end
