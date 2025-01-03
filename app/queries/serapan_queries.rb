class SerapanQueries
  def initialize(kode_opd: '', tahun: '', periode: '')
    @kode_opd = kode_opd
    @tahun = tahun
    @periode = periode
    @tahun_awal = periode.first
    @tahun_akhir = periode.last
  end

  def opd
    Opd.find_by(kode_unik_opd: @kode_opd)
  end

  delegate :bidang_urusan_opd, to: :renstra

  def renstra
    @renstra ||= RenstraQueries.new(kode_opd: @kode_opd,
                                    tahun_awal: @tahun_awal,
                                    tahun_akhir: @tahun_akhir)
  end

  def bidang_urusan_pagu
    bidang_urusan_opd.map do |bid|
      bid_subs = pagu_subkegiatan_opd.select { |pag| pag[:kode_bidang_urusan] == bid[:kode] }
      pagus = @periode.index_with do |tahun|
        bid_subs.sum { |sub| sub[:pagu][tahun] }
      end
      bid.merge(pagu: pagus)
    end
  end

  def pagu_subkegiatan_opd
    subkegiatans = renstra.subkegiatans
    subkegiatans.flat_map do |subs|
      { kode_bidang_urusan: subs[:kode_bidang_urusan],
        pagu: subs[:pagu] }
    end
  end
end
