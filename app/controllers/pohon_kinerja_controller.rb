class PohonKinerjaController < ApplicationController
  skip_before_action :verify_authenticity_token, only: %i[admin_filter filter_rekap]

  def kota; end

  def opd
    @opd = current_user.opd
    # nip_kepala = @opd.users.eselon2.first&.nik
    @pohons = @opd.pohons
    @strategis = @opd.strategis.where(role: 'eselon_2')
  end

  def asn
    @opd = current_user.opd
    @pohons = @opd.pohons
    @user = current_user
    @eselon = @user.eselon_user
    @strategis = Strategi.where(nip_asn: @user.nik).select(&:strategi_atasan)
    @strategi_kepala = @opd.strategis.where(nip_asn: @user.nik, role: 'eselon_2')
  end

  def admin_filter
    @kode_opd = params[:kode_opd]
    @tahun = cookies[:tahun]
    @opd = Opd.find_by(kode_unik_opd: @kode_opd)
    @pohons = @opd.pohons
    @strategis = @opd.strategis.where(role: 'eselon_2')
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
    @tahun = cookies[:tahun] || '2023'
    kode_opd = cookies[:opd]
    @timestamp = Time.now.to_formatted_s(:number)
    @opd = Opd.find_by(kode_unik_opd: kode_opd)
    @pohons = @opd.pohons
    @kotak_usulan = @opd.usulans
    @isu_strategis_pohon = @opd.isu_strategis_pohon
    @filename = "Pohon Kinerja #{@opd.nama_opd} #{@tahun} - #{@timestamp}.xlsx"
    render xlsx: "pohon_opd_excel", filename: @filename, disposition: "inline"
  end

  def excel_kota
    @tahun = cookies[:tahun] || '2023'
    @timestamp = Time.now.to_formatted_s(:number)
    @filename = "Pohon Kinerja Kota #{@tahun} - #{@timestamp}.xlsx"
    @isu_strategis_kota = IsuStrategisKotum.where(tahun: @tahun)
    render xlsx: "pohon_kota_excel", filename: @filename, disposition: "inline"
  end

  def pdf_kota
    @tahun = cookies[:tahun] || '2023'
    @timestamp = Time.now.to_formatted_s(:number)
    @filename = "Pohon Kinerja Kota #{@tahun} - #{@timestamp}"
    @isu_strategis_kota = IsuStrategisKotum.where(tahun: @tahun)
    respond_to do |format|
      format.html { render layout: 'blank' }
      format.pdf do
        render pdf: @filename,
               disposition: 'attachment',
               template: 'pohon_kinerja/pdf_kota.html.erb',
               layout: 'blank',
               show_as_html: params.key?('debug'),
               orientation: 'Landscape',
               image_quality: 100,
               background: true,
               disable_smart_shrinking: true,
               title: "POHON KINERJA KOTA"
      end
    end
  end

  def rekap; end

  def filter_rekap
    @tahun = cookies[:tahun] || '2023'
    @isu_kota = IsuStrategisKotum.where(tahun: @tahun).to_h do |isu_kota|
      [isu_kota, isu_kota.strategi_kotums.to_h do |str_kota|
        [str_kota, str_kota.pohons]
      end]
    end
    render partial: 'pohon_kinerja/filter_rekap'
  end
end
