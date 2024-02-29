class RenjaController < ApplicationController
  before_action :set_renja, except: %i[ranwal rancangan rankir penetapan perubahan]

  def ranwal; end

  def ranwal_renja
    @user = @opd.eselon_dua_opd
    @sasaran_opds = @user.sasaran_pohon_kinerja(tahun: @tahun)
    @tujuan_opds = @opd.tujuan_opds.by_periode(@tahun)
    render partial: 'hasil_filter_ranwal_renja'
  end

  def ranwal_cetak
    @title = "Rawnal Renja"
    @user = @opd.eselon_dua_opd
    @sasaran_opds = @user.sasaran_pohon_kinerja(tahun: @tahun)
    @tujuan_opds = @opd.tujuan_opds.by_periode(@tahun)

    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "ranwal_renja_#{@nama_opd}_tahun_#{@tahun}",
               dispotition: 'attachment',
               orientation: 'Landscape',
               page_size: 'Legal',
               layout: 'pdf.html.erb',
               template: 'renja/ranwal_cetak.html.erb'
      end
      format.xlsx do
        render filename: "ranwal_renja_#{@nama_opd}_tahun_#{@tahun}"
      end
    end
  end

  def rancangan; end

  def rancangan_renja
    @user = @opd.eselon_dua_opd
    @sasaran_opds = @user.sasaran_pohon_kinerja(tahun: @tahun)
    render partial: 'rancangan_renja'
  end

  def rancangan_cetak
    @user = @opd.eselon_dua_opd
    @sasaran_opds = @user.sasaran_pohon_kinerja(tahun: @tahun)
    @tujuan_opds = @opd.tujuan_opds.by_periode(@tahun)
    @title = "Rankir Renja"
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "rancangan_renja_#{@nama_opd}_tahun_#{@tahun}",
               dispotition: 'attachment',
               orientation: 'Landscape',
               page_size: 'Legal',
               layout: 'pdf.html.erb',
               template: 'renja/rancangan_cetak.html.erb'
      end
    end
  end

  def rankir; end

  def rankir_renja
    @user = @opd.eselon_dua_opd
    @tujuan_opds = @opd.tujuan_opds.by_periode(@tahun)
    @sasaran_opds = @user.sasaran_pohon_kinerja(tahun: @tahun)
    renja = RenjaService.new(kode_opd: @kode_opd, tahun: @tahun, jenis: 'rankir')
    @program_kegiatans = renja.program_kegiatan_renja
    render partial: 'rankir_renja'
  end

  def rankir_cetak
    set_ranwal
    @user = @opd.eselon_dua_opd
    @sasaran_opds = @user.sasaran_pohon_kinerja(tahun: @tahun)
    @tujuan_opds = @opd.tujuan_opds.by_periode(@tahun)
    @title = "Rankir Renja"
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "rankir_renja_#{@nama_opd}_tahun_#{@tahun}",
               dispotition: 'attachment',
               orientation: 'Landscape',
               page_size: 'Legal',
               layout: 'pdf.html.erb',
               template: 'renja/rankir_cetak.html.erb'
      end
      format.xlsx do
        render filename: "ranwal_renja_#{@nama_opd}_tahun_#{@tahun}"
      end
    end
  end

  def penetapan; end

  def penetapan_renja
    @kode_opd = params[:kode_opd]
    @tahun = params[:tahun]
    @opd = Opd.find_by(kode_unik_opd: @kode_opd)
    @nama_opd = @opd.nama_opd
    @program_kegiatans = @opd.program_renstra
    render partial: 'penetapan_renja'
  end

  def perubahan; end

  def perubahan_renja
    @kode_opd = params[:kode_opd]
    @tahun = params[:tahun]
    @opd = Opd.find_by(kode_unik_opd: @kode_opd)
    @nama_opd = @opd.nama_opd
    @program_kegiatans = @opd.program_renstra
    render partial: 'perubahan_renja'
  end

  private

  def set_renja
    @tahun = cookies[:tahun]
    @kode_opd = cookies[:opd]
    @opd = Opd.find_by(kode_unik_opd: @kode_opd)
  end
end
