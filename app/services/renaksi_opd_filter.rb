class RenaksiOpdFilter
  def initialize(params = {})
    @scope = RencanaAksiOpd.includes(:sasaran, :rencana_renaksi)
    @params = params
  end

  def results
    filter_by_opd
    filter_by_tahun
    filter_by_tw
    filter_by_bulan
    filter_perintah_walikota
    order_and_compact
    @scope
  end

  def opd_setda
    Opd.find(145)
  end

  private

  def kode_kota?
    @params[:opd] == '0.00.0.00.0.00.00.0000'
  end

  # default filter
  def filter_by_tahun
    return if @params[:tahun].blank?

    tahun = @params[:tahun]
    @scope = @scope.where(tahun: tahun)
  end

  def filter_by_opd
    return if @params[:opd].blank? || kode_kota?

    kode_opd = @params[:opd]
    @scope = @scope.where(kode_opd: kode_opd)
  end

  def filter_by_tw
    return if @params[:triwulan].blank?

    map_triwulan = {
      'I' => 'tw1',
      'II' => 'tw2',
      'III' => 'tw3',
      'IV' => 'tw4'
    }
    triwulan = @params[:triwulan]
    @scope = @scope.where("#{map_triwulan[triwulan]} != '0'")
  end

  def filter_by_bulan
    return if @params[:bulan].blank?

    bulan = @params[:bulan]
    @scope = @scope.select { |rn| rn.target_bulanan_aktif?(bulan) }
  end

  def filter_perintah_walikota
    return unless @params[:jenis_renaksi] == 'perintah-walikota'

    @scope = @scope.select(&:perintah_walikota?)
  end

  def order_and_compact
    @scope = @scope
             .group_by(&:sasaran)
  end
end
