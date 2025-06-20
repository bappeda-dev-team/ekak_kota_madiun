class RekapsController < ApplicationController
  # before_action :kode_opd
  before_action :set_tahun
  def pagu_ranwal; end

  def pagu_ranwal_opds
    pagu = PaguService.new(tahun: @tahun)
    @rekap_ranwal = pagu.program_kegiatan_opd

    render partial: 'rekaps/pagu_ranwal_opds'
  end

  def pagu_rancangan; end

  def pagu_rancangan_opds
    pagu = PaguService.new(tahun: @tahun, jenis: 'rancangan')
    @rekap_ranwal = pagu.program_kegiatan_opd

    render partial: 'rekaps/pagu_rancangan_opds'
  end

  def pagu_rankir; end

  def pagu_rankir_opds
    pagu = PaguService.new(tahun: @tahun, jenis: 'rankir')
    @rekap_ranwal = pagu.program_kegiatan_opd

    render partial: 'rekaps/pagu_rankir_opds'
  end

  def pagu_penetapan; end

  def pagu_penetapan_opds
    pagu = PaguService.new(tahun: @tahun, jenis: 'penetapan')
    @rekap_ranwal = pagu.program_kegiatan_opd

    render partial: 'rekaps/pagu_penetapan_opds'
  end

  def perbandingan_pagu; end

  def perbandingan_pagu_opds
    pagu = PaguService.new(tahun: @tahun, jenis: 'perbandingan')
    @rekap_ranwal = pagu.program_kegiatan_opd

    render partial: 'rekaps/perbandingan_pagu_opds'
  end

  def jumlah; end

  def filter_rekap_pokin_operational
    @tahun = params[:tahun]
    @kode_opd = params[:kode_opd]
    @opd = Opd.find_by(kode_unik_opd: @kode_opd)
    @pokin_operationals = @opd.strategis.eselon4_bytahun(@tahun)

    @pokin_operationals = @pokin_operationals.map do |pokin|
      rekins = pokin.sasarans.where(tahun: @tahun)
      [pokin, rekins] if rekins.present?
    end.compact_blank!

    render partial: 'rekaps/filter_rekap_pokin_operational'
  end

  def cetak_rekap_pokin_operational
    @tahun = params[:tahun]
    @kode_opd = params[:kode_opd]
    @opd = Opd.find_by(kode_unik_opd: @kode_opd)
    @pokin_operationals = @opd.strategis.eselon4_bytahun(@tahun)

    @pokin_operationals = @pokin_operationals.map do |pokin|
      rekins = pokin.sasarans.where(tahun: @tahun)
      [pokin, rekins] if rekins.present?
    end.compact_blank!

    @filename = "REKAP_POKIN_OPERATIONAL_#{@opd.nama_opd}_TAHUN_#{@tahun}.pdf"

    respond_to do |format|
      format.html do
        render template: 'rekaps/cetak_rekap_pokin_operational', layout: 'print.html.erb'
      end
      format.xlsx do
        render xlsx: "cetak_rekap_pokin_operational", filename: @filename, disposition: 'attachment'
      end
    end
  end

  private

  def set_tahun
    @tahun = cookies[:tahun]
  end

  def kode_opd_params
    params[:opd]
  end
end
