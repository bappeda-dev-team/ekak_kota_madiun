class OpdsController < ApplicationController
  before_action :set_opd, only: %i[show edit update destroy]
  before_action :set_dropdown, only: %i[new edit]

  def index
    @opds = Opd.all.includes([:lembaga])
  end

  def info
    respond_to do |f|
      f.html { render :index }
    end
  end

  def all_opd
    @opds = Opd.all.includes([:lembaga])
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
    respond_to do |f|
      if @opd.update(opd_params)
        flash.now[:success] = 'Opd berhasil diupdate.'
        f.js
        f.html { redirect_to @opd, notice: 'Opd berhasil diupdate.' }
      else
        f.html { render :edit, notice: 'Opd gagal diupdate.' }
      end
    end
  end

  def destroy
    @opd.destroy
    respond_to do |f|
      f.html { redirect_to opds_url, notice: 'Opd Berhasil Dihapus.' }
    end
  end

  def tujuan; end

  def sasaran; end

  def kotak_usulan
    # TODO: change opd id
    @opd = Opd.find(136)
    @nama_opd = @opd.nama_opd
    @tahun = 2023
    @kotak_usulan = @opd.usulans
    @pohons = @opd.pohons
  end

  # diperuntukkan eselon 2
  def buat_strategi
    # TODO: change opd id
    @opd = Opd.find(136)
    nip_kepala = @opd.users.eselon2.first.nik
    @jenis_isu = params[:jenis_isu]
    @id_isu = params[:id_isu]
    @usulan_isu = params[:usulan_isu]
    @role = "eselon_2"
    # @role = params[:role]
    @nip = nip_kepala
    # @nip = params[:nip]
    # render partial: 'form_buat_strategi_opd'
  end

  # mekanisme pohon kinerja disini
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
    respond_to do |format|
      pohon_checker = Pohon.where(pohonable_id: @id_isu.to_i, pohonable_type: @jenis_isu, opd_id: @opd.id)
      pohon = if pohon_checker.any?
                pohon_checker.first
              else
                Pohon.create(pohonable_id: @id_isu.to_i, pohonable_type: @jenis_isu,
                             opd_id: @opd.id, keterangan: @usulan_isu)
              end
      strategi = Strategi.create(strategi: @strategi, tahun: @tahun, pohon_id: pohon.id, role: @role, nip_asn: @nip)
      if pohon && strategi
        format.html { redirect_to kotak_usulan_opds_path, success: "Strategi dibuat" }
      else
        format.html { render :buat_strategi, error: 'Terjadi kesalahan' }
      end
    end
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
