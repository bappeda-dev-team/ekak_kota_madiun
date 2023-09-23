module AnggaranPohon
  class Strategic
    def initialize(strategi)
      @strategi = strategi
    end

    def hitung_anggaran
      anggaran_childs
    end

    private

    def child_pohons
      childs = @strategi.strategi_bawahans.map do |tact|
        anggarans = AnggaranPohon::Tactical.new(tact)
        anggarans.hitung_anggaran
      end
    rescue NoMethodError
      false
    end

    def anggaran_childs
      return unless child_pohons

      child_pohons
        .flatten
        .compact_blank.sum
    end
  end
end
