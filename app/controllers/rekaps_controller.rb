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

  def pagu_penetapan; end

  def perbandingan_pagu; end

  def jumlah; end

  private

  def set_tahun
    @tahun = cookies[:tahun]
  end

  def kode_opd_params
    params[:opd]
  end
end
