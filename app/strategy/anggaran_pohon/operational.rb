module AnggaranPohon
  class Operational
    def initialize(sasaran)
      @sasaran = sasaran
    end

    def hitung_anggaran
      "Hello, from operational sasaran #{@sasaran.class}"
    end
  end
end
