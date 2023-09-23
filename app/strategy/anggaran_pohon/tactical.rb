module AnggaranPohon
  class Tactical
    def initialize(strategi)
      @strategi = strategi
    end

    def hitung_anggaran
      anggaran_childs
    end

    private

    def child_pohons
      childs = @strategi.strategi_bawahans
      childs.map(&:sasarans)
    rescue NoMethodError
      false
    end

    def anggaran_childs
      return unless child_pohons

      child_pohons
        .flatten
        .map(&:total_anggaran).compact_blank.sum
    end
  end
end
