class OpdsController < ApplicationController
  before_action :set_opd, only: %i[show edit update destroy]
  before_action :set_dropdown, only: %i[new edit]

  def index
    param = params[:q] || ""

    @opds = Opd.where("nama_opd ILIKE ?", "%#{param}%").where.not(kode_unik_opd: nil)
    return unless params[:item]

    @opds = Opd.where(id: params[:item].where.not(kode_unik_opd: nil))
  end

  def opd_resmi
    param = params[:q] || ""

    @opds = Opd.with_user.where("nama_opd ILIKE ?", "%#{param}%").where.not(kode_unik_opd: nil)
    return unless params[:item]

    @opds = Opd.with_user.where(id: params[:item].where.not(kode_unik_opd: nil))
  end

  def info
    @kode_opd = cookies[:opd]
    @opds = Opd.where(kode_unik_opd: @kode_opd)
    respond_to do |f|
      f.html { render :index }
    end
  end

  def filter_selected
    scope_filter = params[:scope] || ''
    nama_opd = params[:q]
    lembaga_id = cookies[:lembaga_id]
    kode_opd_selected = params[:kode_opd] || params[:selected]
    @opds = if scope_filter == 'all'
              Opd.opd_resmi_kota
                 .where(lembaga_id: lembaga_id, kode_unik_opd: kode_opd_selected)
                 .presence || Opd.opd_resmi_kota.where(lembaga_id: lembaga_id)
            else
              Opd.opd_resmi_kota
                 .where(lembaga_id: lembaga_id, kode_unik_opd: kode_opd_selected)
            end

    @opds = @opds.where("nama_opd ILIKE ?", "%#{nama_opd}%")
  end

  def all_opd
    @nama_lembaga = cookies[:lembaga]
    lembaga_id = cookies[:lembaga_id]
    @opds = Opd.all.includes([:opd_induk])
               .where(lembaga_id: lembaga_id)
               .where.not(kode_unik_opd: nil).order(:kode_unik_opd)
  end

  def legit_opd
    nama_opd = params[:q]
    @opds = Opd.where.not(kode_unik_opd: nil).where("nama_opd ILIKE ?", "%#{nama_opd}%")
    if params[:kode_opd] || params[:kode_opd_terpilih]
      @opds = if params[:role] == "INTERNAL"
                Opd.where(kode_unik_opd: params[:kode_opd]).limit(1)
              else
                @opds.where.not(kode_unik_opd: params[:kode_opd])
                     .where.not(id: params[:kode_opd_terpilih])
              end
    end
    return unless params[:item]

    @opds = Opd.where(kode_unik_opd: params[:item])
  end

  def show; end

  def new
    @opd = Opd.new
  end

  def edit; end

  def create
    @opd = Opd.new(opd_params)
    respond_to do |f|
      if @opd.save
        f.html { redirect_to @opd, notice: 'Opd berhasil ditambahkan.' }
      else
        f.html { render :new, notice: 'Opd gagal ditambahkan' }
      end
    end
  end

  def update
    respond_to do |format|
      if @opd.update(opd_params)
        format.json do
          render json: { resText: "OPD diperbarui", res: @opd }.to_json,
                 status: :ok
        end
      else
        format.json do
          render json: { resText: "Gagal memperbarui", res: @opd.errors }.to_json, status: :unprocessable_entity
        end
      end
    end
  end

  def destroy
    @opd.destroy
    respond_to do |f|
      f.html { redirect_to opds_url, notice: 'Opd Berhasil Dihapus.' }
    end
  end

  def bidang
    @opds = Opd.with_bidang
  end

  def tujuan; end

  def sasaran; end

  def kotak_usulan
    opd_params = params[:kode_opd]
    @opd = if opd_params
             Opd.find(opd_params)
           else
             current_user.opd
           end
    @nama_opd = @opd.nama_opd
    @opd_id = @opd.id
    @tahun = params[:tahun] || 2023
    pokin = PokinQueries.new(opd: @opd, tahun: @tahun)
    @kotak_usulan = @opd.usulans
    # @isu_strategis_pohon = @opd.isu_strategis_pohon(@tahun)
    @isu_strategis_pohon = pokin.isu_strategis
    return unless @opd_id == 145

    render 'kotak_usulan_setda'
  end

  # form buat strategi eselon 2, tombol klik di kotak usulan opd
  def buat_strategi
    # TODO: change opd id
    @opd = current_user.opd
    @opd_id = @opd.id
    nip_kepala = @opd.users.eselon2.first.nik
    @jenis_isu = params[:jenis_isu]
    @id_isu = params[:id_isu]
    @usulan_isu = params[:usulan_isu]
    @role = "eselon_2"
    @nip = nip_kepala
    @users = User.find_by(nik: nip_kepala)
    @sasaran = current_user.sasarans.build
    @sasaran.indikator_sasarans.build
  end

  # mekanisme pohon kinerja disini
  # simpan pohon kinerja opd
  def simpan_strategi
    # TODO: change opd id
    @opd = Opd.find(params[:id])
    @jenis_isu = params[:jenis_isu]
    @id_isu = params[:id_isu]
    @usulan_isu = params[:isu_strategis_opd]
    @strategi = params[:strategi]
    @tahun = params[:tahun]
    @role = params[:role]
    @nip = params[:nip]
    @sasaran = params[:sasaran_kinerja]
    @opd_id = params[:opd_id]
    respond_to do |format|
      pohon_checker = Pohon.where(pohonable_id: @id_isu.to_i, pohonable_type: @jenis_isu, opd_id: @opd.id)
      pohon = if pohon_checker.any?
                pohon_checker.first
              else
                Pohon.create(pohonable_id: @id_isu.to_i, pohonable_type: @jenis_isu,
                             opd_id: @opd.id, keterangan: @usulan_isu)
              end
      strategi = Strategi.create(strategi: @strategi, tahun: @tahun, pohon_id: pohon.id, role: @role, nip_asn: @nip,
                                 opd_id: @opd.id)
      if pohon && strategi
        sasaran = Sasaran.create(sasaran_kinerja: @sasaran, nip_asn: @nip, strategi_id: strategi.id, tahun: @tahun)
        if sasaran
          strategi.update(sasaran_id: sasaran.id)
          random_number = sasaran.id_rencana.nil? ? (SecureRandom.random_number(9e5) + 1e5).to_i : sasaran.id_rencana
          sasaran.update(id_rencana: random_number)
          indikator_sasaran = IndikatorSasaran.create(indikator_kinerja: params[:indikator_kinerja],
                                                      target: params[:target], satuan: params[:satuan],
                                                      aspek: params[:aspek], sasaran_id: random_number)
          format.html { redirect_to kotak_usulan_opds_path, success: "Strategi dibuat" }
        else
          format.html { render :buat_strategi, error: 'Terjadi kesalahan' }
        end
      else
        format.html { render :buat_strategi, error: 'Terjadi kesalahan' }
      end
    end
  end

  def sasaran_tactical
    tahun = cookies[:tahun]
    opd = Opd.find_by(kode_unik_opd: params[:kode_opd])
    cari_sasaran = params[:q]
    @sasarans = opd.find_sasaran_eselon3(cari_sasaran, tahun)
    return unless params[:item]

    @sasarans = Sasaran.where(id: params[:item])
  end

  def strategi_tactical
    tahun = cookies[:tahun]
    opd = Opd.find_by(kode_unik_opd: params[:kode_opd])
    cari = params[:q]
    @strategis = opd.find_strategi_eselon3(cari, tahun)
    return unless params[:item]

    @strategis = Strategi.where(id: params[:item])
  end

  def sasaran_operational
    tahun = cookies[:tahun]
    opd = Opd.find_by(kode_unik_opd: params[:kode_opd])
    cari_sasaran = params[:q]
    @sasarans = opd.find_sasaran_eselon4(cari_sasaran, tahun)
    return unless params[:item]

    @sasarans = Sasaran.where(id: params[:item])
  end

  def edit_full
    @opd = Opd.find(params[:id])
    render partial: 'form_edit_full', locals: { opd: @opd }
  end

  private

  def set_opd
    @opd = Opd.find(params[:id])
  end

  def set_dropdown
    @lembagas = Lembaga.all
  end

  def opd_params
    params.require(:opd).permit!
  end
end
