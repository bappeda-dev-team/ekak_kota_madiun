module AnggaranPohon
  class Tematik
    def initialize(strategi)
      @strategi = strategi
    end

    def hitung_anggaran
      anggaran_total
    end

    def programs
      child_pohons.map(&:programs).flatten.compact_blank.uniq(&:nama_program)
    end

    private

    def child_pohons
      @strategi.strategi_bawahans.map do |tact|
        AnggaranPohon::Tactical.new(tact)
      end
    rescue NoMethodError
      []
    end

    def anggaran_childs
      @strategi.strategi_bawahans.map do |tact|
        anggarans = AnggaranPohon::Tactical.new(tact)
        anggarans.hitung_anggaran
      end
    rescue NoMethodError
      []
    end

    def anggaran_total
      return unless anggaran_childs

      anggaran_childs
        .flatten
        .compact_blank.sum
    end
  end
end
