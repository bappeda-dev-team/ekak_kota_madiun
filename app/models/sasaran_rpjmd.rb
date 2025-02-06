# refactor from menu sasaran_kota / rad ->
# sasaran_kota#handle_filter
class SasaranRpjmd
  def initialize(tahun:)
    @tahun = tahun.to_s
  end

  def tematiks
    Pohon.includes(:pohonable)
         .where(pohonable_type: %w[Tematik], tahun: @tahun)
         .select(&:pohonable)
  end

  def tematik_sasaran_kota
    tematiks.to_h do |tematik|
      sub_pohons = tematik.sub_pohons.includes(:pohonable).where(tahun: @tahun,
                                                                 pohonable_type: %w[
                                                                   SubTematik SubSubTematik Strategic
                                                                 ])
                          .select(&:pohonable)
      [tematik, sub_pohons]
    end
  end

  def sasaran_kota
    tematik_sasaran_kota.values.flatten
  end

  def sasaran_kota_list
    hash_sasaran = sasaran_kota.flat_map do |sas|
      id = sas.pohonable_id
      indikators = sas.pohonable.indikators
      dinas = dinas_terkait(sas)

      {
        id: id,
        sasaran: sas.pohonable.sasaran_kotum&.sasaran,
        indikators: indikators,
        dinas: dinas
      }
    end

    hash_sasaran.select { |ss| ss[:sasaran].present? }
  end

  private

  def dinas_terkait(sas)
    sas_kota = SasaranKota::SasaranComponent.new(sasaran: sas, tahun: @tahun)
    list_opd = sas_kota.sub_pohons
                       .flat_map do |sub|
      if sub.role == 'sub_sub_pohon_kota'
        sub.sub_pohons.map(&:opd)
      else
        sub.opd
      end
    end

    list_opd.flat_map(&:to_s)
            .uniq.compact
  end
end
