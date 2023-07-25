class PohonKinerjaController < ApplicationController
  skip_before_action :verify_authenticity_token, only: %i[admin_filter filter_rekap filter_rekap_opd]
  before_action :clone_params, only: %i[clone_pokin_opd clone_pokin_kota clone_pokin_isu_strategis_opd]

  def manual
    @tahun = cookies[:tahun]
    @kode_opd = cookies[:opd]
    @opd = Opd.find_by(kode_unik_opd: @kode_opd)
    @nama_opd = @opd.nama_opd
    @eselon = current_user.has_role?(:admin) ? 'eselon_2' : current_user.eselon_user
    # @strategis = Strategi.where('tahun ILIKE ?', "%#{@tahun}%")
    #                      .where(opd_id: @opd.id.to_s, role: @eselon)
    @strategis_pohon = StrategiPohon.where(tahun: @tahun)
                                    .where(opd_id: @opd.id.to_s, role: @eselon)
  end

  def pindah
    @tahun = cookies[:tahun]
    @pohon = StrategiPohon.find(params[:id])
    url = pohon_kinerja_path(@pohon)
    method = :patch
    @opd = Opd.find(params[:opd_id])
    @opd_id = @opd.id
    role_atasan = params[:role_atasan]
    @strategis_pohon = StrategiPohon.where(tahun: @tahun)
                                    .where(opd_id: @opd.id.to_s, role: role_atasan)
    # @isu_strategis_pohon = @strategis_pohon
    #                        .uniq(&:pohon_id)
    #                        .collect do |str|
    #   [str.pohon.strategi_kota_isu_strategis, str.pohon_id]
    # end
    @isu_strategis_atasan = @strategis_pohon.pluck(:strategi, :id)
    render partial: 'form_pindah_jalur', locals: { pohon: @pohon, url: url, new_strategi: false, method: method }
  end

  def new
    # NOTE: this is correct way
    # to always spawn indikator
    # at first open form
    @pohon = StrategiPohon.new
    @opd = Opd.find(params[:opd_id])
    @opd_id = @opd.id
    @role = params[:role]
    @isu_pohon = params[:isu_pohon]
    isu = StrategiPohon.find(@isu_pohon)
    @isu_strategis_pohon = [isu.pohon.strategi_kota_isu_strategis, isu.pohon_id]
    @isu_strategis_atasan = [isu.strategi, isu.id]
    @pohon.build_sasaran.indikator_sasarans.build
    url = pohon_kinerja_index_path
    method = :post
    render partial: 'form_new_strategi_pohon', locals: { pohon: @pohon, url: url, new_strategi: true, method: method }
  end

  def edit
    # @pohon = Pohon.find_by(pohonable_id: params[:id]).pohonable
    @pohon = StrategiPohon.find(params[:id])
    url = pohon_kinerja_path(@pohon)
    method = :patch
    render partial: 'form', locals: { pohon: @pohon, url: url, new_strategi: false, method: method }
  end

  def create
    pohon_parameter = pohon_params
    tahun = pohon_parameter[:tahun]
    tahun_bener = tahun.include?('murni') ? tahun[/[^_]\d*/, 0] : tahun
    pohon_parameter[:tahun] = tahun_bener
    @pohon = StrategiPohon.new(pohon_params)
    if @pohon.save
      render json: { resText: "Perubahan tersimpan", result: 'Berhasil' },
             status: :created
    else
      render json: { resText: "Terjadi Kesalahan" },
             status: :unprocessable_entity
    end
  end

  def update
    @pohon = StrategiPohon.find(params[:id])
    if @pohon.update(pohon_params)
      render json: { resText: "Perubahan tersimpan", result: @pohon.id },
             status: :accepted
    else
      render json: { resText: "Terjadi Kesalahan" },
             status: :unprocessable_entity
    end
  end

  def destroy
    @pohon = StrategiPohon.find(params[:id])
    @pohon.destroy
    render json: { resText: "Pohon Dihapus", result: true },
           status: :accepted
  end

  def show
    @tahun = params[:tahun] || cookies[:tahun]
    opd_params = params[:kode_opd] || cookies[:opd]
    @opd = if opd_params
             Opd.find_by(kode_unik_opd: opd_params)
           else
             current_user.opd
           end
    @strategi = StrategiPohon.find(params[:id])
    @strategi_kota = @strategi.pohon.pohonable
    @isu_opd = @strategi_kota.isu_strategis_kotum
    @nama_opd = @opd.nama_opd

    respond_to do |format|
      if @opd.id == 145 || @opd.kode_opd == '1260'
        format.html { render "pohon_kinerja/pdf_setda", layout: 'blank' }
      else
        format.html { render layout: 'blank' }
      end
    end
  end

  def transfer_pohon
    @tahun = cookies[:tahun]
    @tahun_sekarang = @tahun
    @strategi = Strategi.find(params[:id])
    @kode_opd = cookies[:opd]
    @opd = Opd.find_by(kode_unik_opd: @kode_opd)
    @opd_id = @opd.id
    @url = transfer_pohon_kinerja_path(@strategi)
    render partial: 'pohon_kinerja/form_clone'
  end

  def transfer
    strategi = Strategi.find(params[:id])
    id_strategi = strategi.id
    opd_id = strategi.opd_id
    tahun = strategi.tahun
    type = params[:type]
    # type = "StrategiPohon"
    html_btn = "
    <button class='btn btn-sm btn-primary' disabled>
      <i class='fa fa-clone me-2'></i>
      <span>Sudah ditransfer</span>
    </button>
    ".html_safe
    clone = StrategiCloner.call(strategi, tahun: tahun,
                                          type: type,
                                          nip: '',
                                          opd_id: opd_id,
                                          strategi_cascade_link: id_strategi,
                                          traits: [:with_sasarans_new])
    respond_to do |format|
      if clone.persist!
        format.js { render "transfer", locals: { id_strategi: id_strategi, html_btn: html_btn } }
      else
        render json: { resText: "Terjadi Kesalahan" },
               status: :unprocessable_entity
      end
    end
  end

  def panggil_teman
    @tahun = cookies[:tahun]
    @kode_opd = cookies[:opd]
    @strategi = StrategiPohon.find(params[:id])
    @dibagikan = @strategi.pohon_shareds.order(:user_id)
    @role = params[:role]
    @opd = Opd.find_by(kode_unik_opd: @kode_opd)
    @temans = @opd.users.with_role(@role.to_sym).reject { |u| u.strategi_pohons(@strategi.id).any? }
    render partial: 'form_teman'
  end

  def simpan_teman
    strategi = StrategiPohon.find(params[:id])
    @tahun = strategi.tahun
    @role = params[:role]
    nip = params[:nip].compact_blank
    opd_list = params[:opd_list].compact_blank
    dibagikan = params[:dibagikan]
    tidak = params[:tidak_dibagikan]
    keterangan = params[:keterangan]
    if tidak
      hapus_bagikan = dibagikan.nil? ? tidak : (tidak - dibagikan)
      hapus_bagikan.each do |hapus|
        Pohon.find(hapus).delete
      end
    end
    list_pohon_baru = []
    nip.each do |nip_asn|
      user = User.find_by(nik: nip_asn)
      list_pohon_baru.push({ user_id: user.id,
                             tahun: @tahun,
                             role: @role,
                             pohonable_id: strategi.id,
                             pohonable_type: 'StrategiPohon',
                             opd_id: strategi.opd_id.to_i,
                             keterangan: keterangan,
                             strategi_id: strategi.id })
    end
    opd_list.each do |kode_opd|
      opd = Opd.find_by(kode_unik_opd: kode_opd)
      list_pohon_baru.push({ opd_id: opd.id,
                             tahun: @tahun,
                             pohonable_id: strategi.id,
                             pohonable_type: 'StrategiPohon',
                             keterangan: keterangan,
                             strategi_id: strategi.id })
    end
    @pohon = Pohon.create(list_pohon_baru)
    if @pohon
      render json: { resText: "Pembagian Disimpan", result: strategi.id },
             status: :accepted
    else
      render json: { resText: "Terjadi Kesalahan" },
             status: :unprocessable_entity
    end
  end

  def daftar_temans
    id_strategi = params[:id]
    @temans = Pohon.where(strategi_id: id_strategi, pohonable_type: 'StrategiPohon')
    render partial: 'daftar_temans', locals: { temans: @temans }
  end

  def daftar_strategi
    @user = current_user
    @pohon = Pohon.find_by(user_id: @user.id, pohonable_id: params[:id], pohonable_type: 'StrategiPohon')
    @tahun = cookies[:tahun]
    @strategis = @user.strategis.where('tahun ILIKE ?', "%#{@tahun}%")
    render partial: 'daftar_strategi', locals: { strategis: @strategis }
  end

  def pasangkan
    @pohon = Pohon.find(params[:id])
    @strategis = params[:strategi].compact_blank
    list_pohon_baru = []
    @strategis.each do |str|
      strategi = Strategi.find(str)
      list_pohon_baru.push({ user_id: @pohon.user_id,
                             tahun: @pohon.tahun,
                             role: @pohon.role,
                             pohonable_id: strategi.id,
                             pohonable_type: 'Strategi',
                             opd_id: @pohon.opd_id,
                             keterangan: strategi.strategi,
                             strategi_id: @pohon.strategi_id })
    end
    @pohons = Pohon.create(list_pohon_baru)
    if @pohons
      render json: { resText: "Pemasangan Disimpan", result: @pohon.id },
             status: :accepted
    else
      render json: { resText: "Terjadi Kesalahan" },
             status: :unprocessable_entity
    end
  end

  def daftar_linked_strategi
    @pohon = Pohon.find(params[:id])
    @strategis = @pohon.linked_strategis
    render partial: 'daftar_linked_strategi', locals: { strategis: @strategis }
  end

  def kota; end

  def opd
    @tahun = cookies[:tahun]
    @opd = current_user.opd
    # nip_kepala = @opd.users.eselon2.first&.nik
    # @pohons = @opd.pohons
    @strategis = @opd.strategis.where(role: 'eselon_2').where('tahun ILIKE ?', "%#{@tahun}%")
  end

  def asn
    @tahun = cookies[:tahun]
    @opd = current_user.opd
    # @pohons = @opd.pohons
    @user = current_user
    @eselon = @user.eselon_user
    @strategis = current_user.strategis.where('tahun ILIKE ?', "%#{@tahun}%")
  end

  def admin_filter
    @kode_opd = params[:kode_opd]
    @tahun = cookies[:tahun]
    @opd = Opd.find_by(kode_unik_opd: @kode_opd)
    # @pohons = @opd.pohons
    @strategis = @opd.strategis.where(role: 'eselon_2').where('tahun ILIKE ?', "%#{@tahun}%")
    @nama_opd = @opd.nama_opd
    render partial: 'pohon_kinerja/kotak_usulan_asn', locals: { role: 'eselon_2', role_bawahan: 'eselon_3' }
  end

  def print
    @opd = current_user.opd
    # nip_kepala = @opd.users.eselon2.first&.nik
    @pohons = @opd.pohons
    @strategis = @opd.strategis.where(role: 'eselon_2')
  end

  def excel_opd
    @tahun = params[:tahun] || cookies[:tahun]
    opd_params = params[:kode_opd] || cookies[:opd]
    @timestamp = Time.now.to_formatted_s(:number)
    @opd = if opd_params
             Opd.find_by(kode_unik_opd: opd_params)
           else
             current_user.opd
           end
    @nama_opd = @opd.nama_opd
    @isu_opd = @opd.pohon_kinerja_opd(@tahun)
    # @rekap_jumlah = @opd.data_total_pokin(@tahun)
    @filename = "Pohon Kinerja #{@nama_opd} #{@tahun} - #{@timestamp}.xlsx"
    if @opd.id == 145
      render xlsx: "pohon_setda_excel", filename: @filename
    else
      render xlsx: "pohon_opd_excel", filename: @filename
    end
  end

  def excel_kota
    @tahun = cookies[:tahun]
    @timestamp = Time.now.to_formatted_s(:number)
    @filename = "Pohon Kinerja Kota #{@tahun} - #{@timestamp}.xlsx"
    @isu_kota = IsuStrategisKotum.where('tahun ILIKE ?', "%#{@tahun}%").to_h do |isu_kota|
      [isu_kota, isu_kota.strategi_kotums.to_h do |str_kota|
        [str_kota, str_kota.pohons]
      end]
    end
    render xlsx: "pohon_kota_excel", filename: @filename
  end

  def pdf_kota
    @tahun = cookies[:tahun]
    @timestamp = Time.now.to_formatted_s(:number)
    @filename = "Pohon Kinerja Kota #{@tahun} - #{@timestamp}"
    @isu_strategis_kota = IsuStrategisKotum.where('tahun ILIKE ?', "%#{@tahun}%")
    respond_to do |format|
      format.html { render layout: 'blank' }
    end
  end

  def pdf_opd
    @tahun = params[:tahun] || cookies[:tahun]
    opd_params = params[:kode_opd] || cookies[:opd]
    @opd = if opd_params
             Opd.find_by(kode_unik_opd: opd_params)
           else
             current_user.opd
           end
    # pokin = PokinQueries.new(opd: @opd, tahun: @tahun)
    @isu_opd = @opd.pohon_kinerja_opd(@tahun)
    # TODO: fix queries in here and in view
    @nama_opd = @opd.nama_opd
    respond_to do |format|
      if @opd.id == 145 || @opd.kode_opd == '1260'
        format.html { render "pohon_kinerja/pdf_setda", layout: 'blank' }
      else
        format.html { render layout: 'blank' }
      end
    end
  end

  def rekap; end

  def filter_rekap
    @tahun = cookies[:tahun] || '2023'
    @isu_kota = IsuStrategisKotum.where('tahun ILIKE ?', "%#{@tahun}%").to_h do |isu_kota|
      [isu_kota, isu_kota.strategi_kota_tahun(@tahun).to_h do |str_kota|
        [str_kota, str_kota.pohons]
      end]
    end
    render partial: 'pohon_kinerja/filter_rekap'
  end

  def rekap_opd
    @kode_opd = cookies[:opd]
    @opd = Opd.find_by(kode_opd: @kode_opd)
  end

  def review_kota
    @tahun = params[:tahun]
    return unless @tahun

    @isu_kota = IsuStrategisKotum.where('tahun ILIKE ?', "%#{@tahun}%").to_h do |isu_kota|
      [isu_kota, isu_kota.strategi_kota_tahun(@tahun).to_h do |str_kota|
        [str_kota, str_kota.pohons]
      end]
    end
  end

  def review_opd
    @opd_params = params[:kode_opd]
    return unless @opd_params

    @tahun = params[:tahun]
    @opd = Opd.find_by(kode_unik_opd: @opd_params)
    @nama_opd = @opd.nama_opd
    @isu_opd = @opd.pohon_kinerja_opd(@tahun)
    if @opd.id == 145
      @rekap_jumlah = @opd.data_total_pokin_setda(@tahun)
      render 'review_setda'
    else
      @rekap_jumlah = @opd.data_total_pokin(@tahun)
    end
  end

  def filter_rekap_opd
    @tahun = cookies[:tahun] || '2023'
    opd_params = cookies[:opd]
    @opd = if opd_params
             Opd.find_by(kode_unik_opd: opd_params)
           else
             current_user.opd
           end
    @nama_opd = @opd.nama_opd
    pokin = PokinQueries.new(opd: @opd, tahun: @tahun)
    @strategis = pokin.strategi_by_role(pokin.strategi_in_specific_opd)
    @strategic = @strategis['eselon_2']
    @rekap_jumlah = pokin.data_total_pokin
    render partial: 'pohon_kinerja/filter_rekap_opd'
  end

  def clone_list_opd
    @isu_strategis = params[:isu_strategis]
    @opd_id = params[:opd_id]
    @tahun_sekarang = params[:tahun_sekarang]
    jenis = params[:jenis]
    tipe_isu = params[:tipe_isu]
    @url = if jenis == 'opd' && tipe_isu == 'IsuStrategisKotum'
             clone_pokin_opd_pohon_kinerja_index_path
           elsif jenis == 'opd' && tipe_isu == 'IsuStrategisOpd'
             clone_pokin_isu_strategis_opd_pohon_kinerja_index_path
           else
             clone_pokin_kota_pohon_kinerja_index_path
           end
    render partial: 'pohon_kinerja/form_clone'
  end

  def clone
    @strategi = Strategi.find params[:strategi]
    @tahun_sekarang = @strategi.tahun
    @pohon = @strategi.pohon
    render partial: 'pohon_kinerja/form_clone_new'
  end

  def set_clone
    @strategi = Strategi.find params[:id]
    pohon = @strategi.pohon
    # tahun clone
    @kelompok_anggaran_id = params[:kelompok_anggaran]
    tahun_asal = @strategi.tahun
    tahun_anggaran = KelompokAnggaran.find(@kelompok_anggaran_id).kode_tahun_sasaran
    clone = PohonCloner.call(pohon,
                             tahun: tahun_anggaran,
                             tahun_asal: tahun_asal,
                             traits: [:with_strategi_sasaran])
    # redirect_to rekap_opd_pohon_kinerja_index_path, error: "Terjadi keslahan cloning"
    if clone.persist!
      render json: { resText: 'Sukses Cloning' }, status: :created
    else
      render json: { resText: 'Gagal Cloning' }, status: :unprocessable_entity
    end
  end

  def clone_pokin_opd
    if isu_straegis_cloned?
      redirect_to rekap_opd_pohon_kinerja_index_path, warning: "sudah dicloning"
    else
      cloner_opd(@isu_strategis_id, @kelompok_anggaran_id, @opd_id, @tahun_asal)
      redirect_to rekap_opd_pohon_kinerja_index_path, success: "Cloned"
    end
  end

  def clone_pokin_kota
    if isu_straegis_cloned?
      redirect_to rekap_pohon_kinerja_index_path, warning: "sudah dicloning"
    else
      cloner_kota(@isu_strategis_id, @kelompok_anggaran_id, @tahun_asal)
      redirect_to rekap_pohon_kinerja_index_path, success: "Cloned"
    end
  end

  def clone_pokin_isu_strategis_opd
    if isu_straegis_opd_cloned?
      redirect_to rekap_opd_pohon_kinerja_index_path, warning: "sudah dicloning"
    else
      cloner_isu_opd(@isu_strategis_id, @kelompok_anggaran_id, @opd_id, @tahun_asal)
      redirect_to rekap_opd_pohon_kinerja_index_path, success: "Cloned"
    end
  end

  private

  def clone_params
    @opd_id = params[:opd_id]
    @isu_strategis_id = params[:isu_strategis_id]
    @kelompok_anggaran_id = params[:kelompok_anggaran]
    @tahun_asal = params[:tahun_asal]
  end

  def isu_straegis_cloned?
    isu_asli = IsuStrategisKotum.find(@isu_strategis_id).isu_strategis
    IsuStrategisKotum.where('kode ILIKE ?', "%#{isu_asli}%").where('keterangan ILIKE ?', '%clone%').any?
  end

  def isu_straegis_opd_cloned?
    isu_asli = IsuStrategisOpd.find(@isu_strategis_id).isu_strategis
    IsuStrategisOpd.where('kode ILIKE ?', "%#{isu_asli}%").where('keterangan ILIKE ?', '%clone%').any?
  end

  def cloner_opd(isu_strategis_id, kelompok_anggaran_id, opd_id, tahun_asal)
    tahun_anggaran = KelompokAnggaran.find(kelompok_anggaran_id).kode_kelompok
    isu_strategis = IsuStrategisKotum.find(isu_strategis_id)
    clone = IsuStrategisKotumCloner.call(isu_strategis,
                                         tahun: tahun_anggaran,
                                         tahun_asal: tahun_asal,
                                         opd_id: opd_id,
                                         traits: [:per_opd])
    clone.persist!
  end

  def cloner_kota(isu_strategis_id, kelompok_anggaran_id, tahun_asal)
    tahun_anggaran = KelompokAnggaran.find(kelompok_anggaran_id).kode_kelompok
    isu_strategis = IsuStrategisKotum.find(isu_strategis_id)
    clone = IsuStrategisKotumCloner.call(isu_strategis,
                                         tahun: tahun_anggaran,
                                         tahun_asal: tahun_asal,
                                         traits: [:all_opd])
    clone.persist!
  end

  def cloner_isu_opd(isu_strategis_id, kelompok_anggaran_id, opd_id, tahun_asal)
    tahun_anggaran = KelompokAnggaran.find(kelompok_anggaran_id).kode_kelompok
    isu_strategis = IsuStrategisOpd.find(isu_strategis_id)
    clone = IsuStrategisOpdCloner.call(isu_strategis,
                                       tahun: tahun_anggaran,
                                       tahun_asal: tahun_asal,
                                       opd_id: opd_id,
                                       traits: [:per_opd])
    clone.persist!
  end

  def pohon_params
    params.require(:strategi_pohon).permit(:strategi,
                                           :role,
                                           :pohon_id,
                                           :tahun,
                                           :nip_asn,
                                           :opd_id,
                                           :strategi_ref_id,
                                           sasaran_attributes: [:sasaran_kinerja, :id_rencana,
                                                                indikator_sasarans_params])
  end

  def indikator_sasarans_params
    { indikator_sasarans_attributes: %i[id
                                        indikator_kinerja
                                        aspek
                                        target
                                        satuan
                                        _destroy] }
  end
end
