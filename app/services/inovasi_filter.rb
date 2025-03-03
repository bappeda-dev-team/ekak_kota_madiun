# filtering inovasi by
# opd
# tahun
# misi_id
# manfaat (asta_karya)
class InovasiFilter
  def initialize(scope = Inovasi.all, params = {})
    @scope = scope
    @params = params
  end

  def results
    filter_by_tahun
    filter_by_opd
    filter_by_manfaat
    filter_by_misi_id
    @scope
  end

  private

  def filter_by_tahun
    return if @params[:tahun].blank?

    @scope = @scope.where(tahun: @params[:tahun])
  end

  def kode_kota?
    @params[:opd] == '0.00.0.00.0.00.00.0000'
  end

  def kode_setda?
    @params[:opd] == '4.01.0.00.0.00.01.0000'
  end

  def filter_by_opd
    return if @params[:opd].blank? || kode_kota?

    @scope = @scope.left_outer_joins(:kolabs)
                   .where('inovasis.opd = :opd OR kolabs.kode_unik_opd = :opd', opd: @params[:opd])
  end

  def filter_by_manfaat
    return if @params[:manfaat].blank?

    @scope = @scope.where(manfaat: @params[:manfaat])
  end

  def filter_by_misi_id
    return if @params[:misi_id].blank?

    @scope = @scope.where(misi_id: @params[:misi_id])
  end
end
