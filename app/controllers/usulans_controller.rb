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
    sasaran_id = params[:sasaran_id]
    usulan = params[:usulan_id].to_i
    usulan_type = params[:usulan_type]
    tahun = params[:tahun]
    opd_id = params[:opd_id].to_i

    u = Usulan.create(usulanable_id: usulan,
                      usulanable_type: usulan_type,
                      sasaran_id: sasaran_id, opd_id: opd_id,
                      tahun: tahun)
    respond_to do |format|
      if u.save
        usulan = u.usulanable
        sasaran_update = u.sasaran
        usulan.update(status: 'menunggu_persetujuan')

        if usulan_type == 'Mandatori'
          sasaran_update.dasar_hukums.create!(usulan_id: u.id, judul: usulan.peraturan_terkait, peraturan: usulan.uraian,
                                              tahun: usulan.tahun)
        else
          # usulan_id -> Usulan (polymorph) id
          sasaran_update.permasalahans.create!(usulan_id: u.id, jenis: 'Umum', permasalahan: usulan.uraian,
                                               tahun: usulan.tahun)
        end
        flash.now[:success] = 'Usulan berhasil ditambahkan'
        format.js { render 'update_sasaran_asn' }
      else
        flash.now[:error] = 'Terjadi kesalahan'
        format.js { render 'update_sasaran_asn', status: :unprocessable_entity }
      end
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
    # logic hapus dasar_hukum / permasalahan by usulan
    # if usulan_type == 'Mandatori'
    #   sasaran_update.dasar_hukums.create!(usulan_id: u.id, judul: usulan.peraturan_terkait, peraturan: usulan.uraian,
    #                                       tahun: usulan.tahun)
    # else
    #   # usulan_id -> Usulan (polymorph) id
    #   sasaran_update.permasalahans.create!(usulan_id: u.id, jenis: 'Umum', permasalahan: usulan.uraian,
    #                                        tahun: usulan.tahun)
    # end

    respond_to do |format|
      format.html { redirect_to sasaran_path(@sasaran), success: 'Usulan berhasil dihapus' }
      format.json { head :no_content }
    end
  end

  def laporan_inovasi
    # @kode_opd = cookies[:opd]
    @kode_opd = "0.00.0.00.0.00.00.0000"
    @tahun = cookies[:tahun]
  end

  def filter_inovasi
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

    # @inovasis = if @opd.is_kota
    #               Inovasi.where(tahun: @tahun)
    #               # Inovasi.by_periode(@tahun_awal, @tahun_akhir)
    #             else
    #               Inovasi.where(tahun: @tahun)
    #                      .select do |inovasi|
    #                 inovasi.opd == @kode_opd || inovasi&.sasaran&.user&.opd&.kode_unik_opd == @kode_opd
    #               end
    #               # Inovasi.by_periode(@tahun_awal, @tahun_akhir)
    #               #        .where(opd: @kode_opd)
    #             end
    # no differentiate version
    @inovasis = Inovasi.where(tahun: @tahun)

    render partial: 'usulans/filter_inovasi'
  end

  private

  def check_params
    return unless params[:usulan_type].empty? && params[:usulan_id].empty?

    render 'shared/_notifier', locals: { message: 'Usulan belum diambil' }, status: :unprocessable_entity
  end
end
