module AnggaranPohon
  class Tematik
    def initialize(subtema, tahun)
      @subtema = subtema
      @tahun = tahun
    end

    def hitung_anggaran
      anggaran_total
    end

    def programs
      child_pohons.map(&:programs).flatten.compact_blank.uniq(&:nama_program)
    end

    private

    def child_pohons
      pohon = Pohon.find_by(pohonable_id: @subtema.id, pohonable_type: @subtema.class.name, tahun: @tahun)
      pohons = Pohon.where(pohon_ref_id: pohon.id)
      strategics = pohons.select { |s| s.role == 'strategi_pohon_kota' }.map do |str|
        strategic = str.pohonable
        AnggaranPohon::Strategic.new(strategic)
      end
      subs = pohons.select { |ph| ph.role == 'sub_pohon_kota' }.map do |sub|
        sub_sub = sub.pohonable
        AnggaranPohon::SubTematik.new(sub_sub, @tahun)
      end
      strategics + subs
    rescue NoMethodError
      []
    end

    def anggaran_childs
      child_pohons.map(&:hitung_anggaran)
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
