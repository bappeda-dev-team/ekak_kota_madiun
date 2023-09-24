module AnggaranPohon
  class SubSubTematik
    def initialize(subtema)
      @subtema = subtema
    end

    def hitung_anggaran
      anggaran_total
    end

    def programs
      child_pohons.map(&:programs).flatten.compact_blank.uniq(&:nama_program)
    end

    private

    def child_pohons
      pohon = Pohon.find_by(pohonable_id: @subtema.id, pohonable_type: @subtema.class.name)
      pohons = Pohon.where(pohon_ref_id: pohon.id)
      pohons.map do |str|
        AnggaranPohon::Strategic.new(str)
      end
    rescue NoMethodError
      []
    end

    def anggaran_childs
      child_pohons.map do |str|
        anggarans = AnggaranPohon::Strategic.new(str)
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
