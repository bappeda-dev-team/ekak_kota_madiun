class RenaksiOpdFilter
  def initialize(scope = Strategi.where(role: 'eselon_2'), params = {})
    @scope = scope.includes(:opd)
    @params = params
  end

  def results
    filter_by_opd
    filter_by_tahun
    order_and_compact
    filter_perintah_walikota
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
    @scope = @scope.flat_map { |st| st&.sasaran_pohon_kinerja(tahun: tahun) }
  end

  def filter_by_opd
    return if @params[:opd].blank? || kode_kota?

    kode_opd = @params[:opd]
    opd_id = Opd.find_by(kode_unik_opd: kode_opd).id

    @scope = @scope.where(opd_id: opd_id)
  end

  def order_and_compact
    @scope = @scope
             .select(&:opd)
             .sort_by { |ss| ss.strategi.opd.kode_unik_opd }
             .compact_blank
  end

  def filter_perintah_walikota
    return unless @params[:jenis_renaksi] == 'perintah-walikota'

    @scope = @scope.select do |ss|
      ss.renaksi_sasaran_walikota.any?
    end
  end
end
