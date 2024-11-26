class PelaksanaController < ApplicationController
  before_action :set_pelaksana, only: %i[show edit update destroy teman]
  before_action :set_tahun_opd

  layout false

  def index; end

  def show
    @pelaksanas = @pelaksana.cascading
  end

  def edit
    @role = params[:role]
    @roles = [@role]
    if @role == 'eselon_3'
      @roles.push('eselon_2b')
    elsif @role == 'eselon_4'
      @roles.push('staff')
    else
      @roles
    end
    @roles << 'plt'
  end

  def edit_role_tim
    @pohon = Pohon.find(params[:id])
    @pelaksana = User.find_by(nik: params[:nip])
    @role_tim = %w[
      Koordinator
      Ketua
      Anggota
    ]
  end

  def update_role_tim
    @pelaksana = User.find_by(nik: params[:nip])
    @pohon = Pohon.find(params[:id])
    @role_tim = %w[
      Koordinator
      Ketua
      Anggota
    ]
    role_tim = params[:role_tim]
    keterangan = params[:keterangan]

    @pohon.update(tim_id: @pohon.id,
                  keterangan_tim: keterangan,
                  role_tim: role_tim,
                  assigned_by: current_user.id,
                  tahun_tim: @pohon.tahun,
                  opd_tim: @pohon.pohonable.opd.kode_unik_opd)

    render json: { resText: "Role Tim Disimpan",
                   html_content: html_content({ pelaksana: @pohon },
                                              partial: 'pelaksana/pelaksana') }.to_json,
           status: :ok
  end

  def teman
    param = params[:q] || ''
    role = params[:role]
    asn_list = @opd.asn_list(nama: param, role: role)
    @temans = asn_list.reject do |u|
      u.strategi_pohon_diterima(@pelaksana.id, @opd.id).any?
    end
  end

  def update
    check = params[:check]
    uncheck = params[:uncheck]
    keterangan = params[:keterangan]
    role = params[:role]
    hapus_cross = check.nil? ? uncheck : (uncheck - check)
    pohons = Pohon.where(id: hapus_cross)

    pohons.update_all(
      pohonable_id: '',
      pohonable_type: '',
      role: 'pelaksana-batal',
      keterangan: keterangan,
      status: 'pelaksana-batal',
      metadata: {
        dibatalkan_by: current_user.id,
        dibatalkan_at: DateTime.current
      }
    )
    list_pohon_baru = []
    asn_list = params[:asn_list].compact_blank
    asn_list.each do |nip_asn|
      user = User.find_by(nik: nip_asn)
      list_pohon_baru.push({ user_id: user.id,
                             tahun: @tahun,
                             role: role,
                             pohonable_id: @pelaksana.id,
                             pohonable_type: 'StrategiPohon',
                             keterangan: keterangan,
                             status: 'cascading',
                             strategi_id: @pelaksana.id,
                             metadata: {
                               dibagikan_by: current_user.id,
                               dibagikan_at: DateTime.current
                             } })
    end

    cross_baru = Pohon.create(list_pohon_baru) if list_pohon_baru.any?

    if pohons.any? || cross_baru
      strategi = @pelaksana.strategi
      render json: { resText: "Pelaksana berhasil diperbarui",
                     html_content: html_content({ pohon: strategi },
                                                partial: 'pohon_kinerja_opds/item_cascading') }.to_json,
             status: :ok
    else
      render json: { resText: "terjadi kesalahan", errors: error_content }.to_json,
             status: :unprocessable_entity
    end
  end

  # rubocop: disable Metrics
  def toggle_inovator
    list_pohons = params[:inovatorState]
    # simpan pohon
    list_pohons.each do |pohon|
      pohonk = Pohon.find(pohon["id"])
      checked = pohon["checked"]
      pohonk.is_inovator = checked
      pohonk.save
    end
    @sasaran = Sasaran.find(params[:sasaran_id])
    @kode_opd = @sasaran.opd.kode_unik_opd
    @tahun = @sasaran.tahun
    @strategi = @sasaran.strategi
    @strategi_atasan = @strategi.strategi_atasan
    @inovasi = @sasaran.inovasi_sasaran
    @kebaruan = @sasaran.gambaran_nilai_kebaruan
    tim_kerja = TimKerja.new(kode_opd: @kode_opd,
                             tahun: @sasaran.tahun)
    @tim = tim_kerja.tim_kerja_hash(@strategi_atasan)

    render json: { resText: "Inovator diupdate",
                   html_content: html_content({ tim: @tim[:susunan_tim], penanggung_jawab: @tim[:penanggung_jawab], sasaran_id: @sasaran.id },
                                              partial: 'tim_kerja/tabel_susunan_tim') }.to_json,
           status: :ok
  end

  # def html_content(pohon)
  #   render_to_string(partial: 'pohon_kinerja_opds/item_cascading',
  #                    formats: 'html',
  #                    layout: false,
  #                    locals: { pohon: pohon })
  # end

  def error_content
    render_to_string(partial: 'form',
                     formats: 'html',
                     layout: false,
                     locals: { pelaksana: @pelaksana })
  end

  def destroy
    pohon_pelaksana = Pohon.find(params[:id])
    user = User.find(params[:user_id])

    pohon_pelaksana.pohonable
                   .sasarans.where(user: user)
                   .update_all(strategi_id: '')

    pohon_pelaksana.destroy
    render json: { resText: "Berhasil hapus pelaksana", result: true },
           status: :accepted
  end

  private

  def set_tahun_opd
    @tahun = cookies[:tahun]
    @kode_opd = cookies[:opd]
    @opd = Opd.find_by(kode_unik_opd: @kode_opd)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_pelaksana
    @pelaksana = Pelaksana.new(params[:id])
  end
end
