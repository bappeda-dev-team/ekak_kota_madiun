module AnggaranPohon
  class Operational
    def initialize(sasaran)
      @sasaran = sasaran
    end

    def programs
      @sasaran.sasarans.flat_map(&:program_kegiatan).compact_blank
    end

    def hitung_anggaran
      @sasaran.total_anggaran
    end
  end
end
