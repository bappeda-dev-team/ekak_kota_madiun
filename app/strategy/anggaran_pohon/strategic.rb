module AnggaranPohon
  class Strategic
    def initialize(sasaran)
      @sasaran = sasaran
    end

    def hitung_anggaran
      "strategic #{@sasaran.class}"
    end
  end
end
