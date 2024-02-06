class IsuDanPermasalahan
  extend Memoist

  attr_accessor :kode_opd
  attr_reader :opd

  def initialize(kode_opd:, tahun: '')
    @tahun = tahun
    @kode_opd = kode_opd
    @opd = Opd.find_by(kode_unik_opd: kode_opd)
  end

  def tahun_asli
    @tahun.include?('perubahan') ? @tahun.gsub('_perubahan', '') : @tahun
  rescue NoMethodError
    ''
  end

  def list_bidang_urusans
    @opd.list_bidang_urusans
  rescue NoMethodError
    []
  end

  def isu_strategis
    @opd.isu_strategis_opds
        .where("tahun ILIKE ?", "%#{tahun_asli}%")
        .order(:id).group_by { |isu| "(#{isu.kode_bidang_urusan}) #{isu.bidang_urusan}" }
  rescue NoMethodError
    []
  end
end
