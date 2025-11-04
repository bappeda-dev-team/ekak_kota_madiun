class UsulansController < ApplicationController
  before_action :check_params, only: %i[update_sasaran_asn]

  def index
    @tahun = cookies[:tahun] || Date.current.year
    if current_user.has_role?(:admin)
      render 'usulans/admin'
    else
      @musrenbangs = current_user.opd.musrenbang_opd
      @mandatoris = current_user.mandatoris_tahun(@tahun)
      @pokpirs = current_user.pokpirs
    end
  end

  def update_sasaran_asn
    sasaran_id = params[:sasaran_id].to_i
    usulan_id = params[:usulan_id].to_i
    usulan_type = params[:usulan_type]
    tahun = params[:tahun]
    opd_id = params[:opd_id].to_i

    u = Usulan.create(usulanable_id: usulan_id,
                      usulanable_type: usulan_type,
                      sasaran_id: sasaran_id,
                      opd_id: opd_id,
                      tahun: tahun)
    if u.save
      usulan_asli = u.usulanable
      sasaran_update = u.sasaran

      usulan_asli.update(status: 'menunggu_persetujuan')

      usulan_asli.update(sasaran_id: sasaran_id) if usulan_type == "Inovasi"

      if usulan_type == 'Mandatori'
        sasaran_update.dasar_hukums.create!(usulan_id: u.id,
                                            judul: usulan_asli.peraturan_terkait,
                                            peraturan: usulan_asli.uraian,
                                            tahun: usulan_asli.tahun)
      else
        # usulan_id -> Usulan (polymorph) id
        sasaran_update.permasalahans.create!(usulan_id: u.id, jenis: 'Umum',
                                             permasalahan: usulan_asli.uraian,
                                             tahun: usulan_asli.tahun)
      end
      render json: { resText: "Usulan berhasil ditambahkan",
                     html_content: html_content({ usulan: u,
                                                  sasaran: sasaran_update },
                                                partial: 'usulans/row_usulan_card_component') }.to_json,
             status: :ok
    else
      render json: { resText: 'Terjadi kesalahan',
                     html_content: error_content({ usulan: u,
                                                   sasaran: sasaran_update },
                                                 partial: 'usulans/row_usulan_card_component') }.to_json,
             status: :unprocessable_entity
    end
  end

  def laporan_usulan
    # render laporan usulan
    @jenis = params[:jenis]
    @jenis_asli = @jenis
    @jenis_asli = 'inisiatif walikota' if @jenis == 'inisiatif'
  end

  def pdf_usulan
    # render laporan usulan
    @jenis = params[:jenis]
    @jenis_asli = @jenis
    @kode_opd = params[:opd]
    if @jenis == 'Inisiatif Walikota'
      @jenis = 'Inovasi'
      @jenis_asli = 'inisiatif walikota'
    end
    if @kode_opd == 'all_opd'
      @program_kegiatans = ProgramKegiatan.includes(%i[opd usulans])
                                          .where(usulans: { usulanable_type: @jenis })
                                          .select { |p| p.sasarans.exists? }
      @nama_opd = 'all_opd'
    else
      @program_kegiatans = ProgramKegiatan.includes(%i[opd usulans]).where(opds: { id_opd_skp: @kode_opd })
                                          .where(usulans: { usulanable_type: @jenis })
                                          .select { |p| p.sasarans.exists? }
      @nama_opd = Opd.find_by(id_opd_skp: @kode_opd).nama_opd
    end
    @nama_file = @nama_opd
    @tahun = params[:tahun] || Time.now.year
    @waktu = Time.now.strftime("%d_%m_%Y_%H_%M")
    @filename = "Laporan_USULAN_#{@jenis_asli}_#{@nama_file}_#{@waktu}.pdf"
  end

  def excel_usulan
    # render laporan usulan
    @jenis = params[:jenis]
    @jenis_asli = @jenis
    @kode_opd = params[:opd]
    if @jenis == 'Inisiatif Walikota'
      @jenis = 'Inovasi'
      @jenis_asli = 'inisiatif walikota'
    end
    if @kode_opd == 'all_opd'
      @program_kegiatans = ProgramKegiatan.includes(%i[opd usulans])
                                          .where(usulans: { usulanable_type: @jenis })
                                          .select { |p| p.sasarans.exists? }
      @nama_opd = 'all_opd'
    else
      @program_kegiatans = ProgramKegiatan.includes(%i[opd usulans]).where(opds: { id_opd_skp: @kode_opd })
                                          .where(usulans: { usulanable_type: @jenis })
                                          .select { |p| p.sasarans.exists? }
      @nama_opd = Opd.find_by(id_opd_skp: @kode_opd).nama_opd
    end
    @nama_file = @nama_opd
    @tahun = params[:tahun] || Time.now.year
    @waktu = Time.now.strftime("%d_%m_%Y_%H_%M")
    @filename = "Laporan_USULAN_#{@jenis_asli}_#{@nama_file}_#{@waktu}.xlsx"
    render xlsx: "excel_usulan", filename: @filename, disposition: :attachment
  end

  def destroy
    @sasaran = Sasaran.find(params[:sasaran_id])
    usulan_id = params[:id]
    @usulan = @sasaran.usulans.find(usulan_id)
    @usulan.usulanable.update(sasaran_id: nil)
    @usulan.destroy
    render json: { resText: "Usulan berhasil dihapus" }.to_json,
           status: :accepted
  end

  def laporan_inovasi
    @kode_opd = "0.00.0.00.0.00.00.0000"
    @tahun = cookies[:tahun]
    @misi_id = ''
    @asta_karya = ''
  end

  def filter_inovasi
    @tahun = params[:tahun]
    @kode_opd = params[:opd]

    @opd = Opd.unscoped.find_by(kode_unik_opd: @kode_opd)

    inovasi_kota = Inovasi.from_kota.with_association
    @inovasis = InovasiFilter.new(inovasi_kota,
                                  params)
                             .results

    @total_pagu = @inovasis.map { |ino| ino.total_pagu_usulans_tahun(@tahun) }.compact.sum

    render partial: 'usulans/filter_inovasi'
  end

  # cetak inovasi - satu kota | no option opd
  def cetak_program_unggulans
    @kode_opd = params[:opd]
    @opd = Opd.unscoped.find_by(kode_unik_opd: @kode_opd)
    @tahun = params[:tahun]
    @inovasis = Inovasi.from_kota.includes(%i[usulans reviews sasaran kolabs misi]).where(tahun: @tahun)
    @total_pagu = @inovasis.map(&:total_pagu_usulans).compact.sum
    respond_to do |format|
      format.html do
        render template: 'usulans/cetak_program_unggulans.html.erb',
               layout: 'print.html.erb'
      end
      format.xlsx do
        render filename: "program_unggulan_walikota_#{@tahun}"
      end
    end
  end

  private

  def check_params
    return unless params[:usulan_type].empty? && params[:usulan_id].empty?

    render 'shared/_notifier', locals: { message: 'Usulan belum diambil' }, status: :unprocessable_entity
  end
end
