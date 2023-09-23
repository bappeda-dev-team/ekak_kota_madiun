module AnggaranPohon
  class Operational
    def initialize(sasaran)
      @sasaran = sasaran
    end

    def hitung_anggaran
      @sasaran.total_anggaran
    end
  end
end
