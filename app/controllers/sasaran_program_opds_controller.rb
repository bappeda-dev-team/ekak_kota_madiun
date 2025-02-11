class SasaranProgramOpdsController < ApplicationController
  layout false, only: [:add_dampak_resiko]

  def spip; end

  def excel_spip
    @opd = Opd.find_by(kode_unik_opd: params[:kode_unik_opd])
    @filename = "Template_import_Kota_Madiun #{@opd.nama_opd}.xlsx"
    render xlsx: "excel_spip", filename: @filename, disposition: "attachment"
  end

  def daftar_resiko
    @tahun = cookies[:tahun]
    @kode_opd = cookies[:opd]
  end

  def show_manrisk
    @tahun = cookies[:tahun]
    @kode_opd = cookies[:opd]
    daftar_resiko = DaftarResiko.new(kode_unik_opd: @kode_opd, tahun: @tahun)
    @opd = Opd.find_by(kode_unik_opd: @kode_opd)
    @tahun_bener = daftar_resiko.tahun
    @program_kegiatans = daftar_resiko.daftar_resiko_sasaran(sasaran_id: params[:id])
  end

  def add_dampak_resiko
    @nomor = params[:nomor_sasaran]
    @sasaran = Sasaran.find params[:sasaran_program_opd_id]
    render partial: 'sasaran_program_opds/form_dampak', locals: { sasaran: @sasaran, nomor: @nomor }
  end

  def verifikasi_dampak_resiko
    @sasaran = Sasaran.find params[:sasaran_program_opd_id]
    @rincian = @sasaran.rincian
    render partial: 'sasaran_program_opds/verifikasi_dampak_resiko'
  end

  def cetak_daftar_resiko
    @laporan = params[:laporan]
    @tahun = params[:tahun] || Time.now.year
    @opd = Opd.find(params[:opd])
    @user = current_user
    @daftar_resiko = DaftarResiko.new(kode_unik_opd: @opd.kode_unik_opd, tahun: @tahun)
    @tahun_bener = @daftar_resiko.tahun
    @program_kegiatans =
      if @laporan == "admin"
        @daftar_resiko.daftar_resiko_opd
      elsif @user.has_role?(:eselon_4)
        @daftar_resiko.daftar_resiko_asn(nip: @user.nik)
      elsif @user.has_role?(:eselon_3)
        @daftar_resiko.daftar_resiko_eselon3(nip: @user.nik)
      end
    # @tahun = @tahun.match(/murni/) ? @tahun[/[^_]\d*/, 0] : @tahun
    # @program_kegiatans = @opd.program_kegiatans.joins(:sasarans).where(sasarans: { tahun: @tahun }).group(:id)
    @filename = "LAPORAN_DAFTAR_RESIKO_#{@opd.nama_opd}_TAHUN_#{@tahun}.pdf"
    pdf = DaftarResikoPdf.new(opd: @opd, tahun: @tahun_bener, program_kegiatans: @program_kegiatans)
    respond_to do |format|
      format.pdf { send_data(pdf.render, filename: @filename, type: 'application/pdf', disposition: :attachment) }
      format.xlsx do
        render xlsx: "cetak_daftar_resiko", filename: @filename, disposition: 'attachment'
      end
    end
  end
end
