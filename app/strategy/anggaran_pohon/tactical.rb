module AnggaranPohon
  class Tactical
    def initialize(sasaran)
      @sasaran = sasaran
    end

    def hitung_anggaran
      "tactical #{@sasaran.class}"
    end
  end
end
