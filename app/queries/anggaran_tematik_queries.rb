class AnggaranTematikQueries
  def initialize(tahun: '', tematik_id: nil)
    @tahun = tahun
    @tematik_id = tematik_id
    @pohon = PohonTematikQueries.new(tahun: @tahun)
  end

  def tematik
    @pohon.tematiks.find_by!(pohonable_id: @tematik_id).pohonable
  end

  def strategy_anggaran
    AnggaranPohon::Tematik.new(tematik, @tahun)
  end

  def tematik_childs
    get_childs(strategy_anggaran.childs) # get Sasaran Operational with ProgramKegiatan
      .flatten
      .select { |chl| chl.program_kegiatan.presence && chl.opd.presence }
  end

  def all_programs
    tematik_childs.map do |sasaran| # list of Sasaran
      {
        kode_opd: sasaran.opd.kode_unik_opd,
        nama_opd: sasaran.opd.nama_opd,
        kode_program: sasaran.program_kegiatan.kode_program,
        nama_program: sasaran.program_kegiatan.nama_program,
        pagu: sasaran.total_anggaran.to_i
      }
    end
  end

  def program_with_pagu
    opds = all_programs.group_by { |opd| [opd[:kode_opd], opd[:nama_opd]] }
    opd_programs = opds.transform_values { |aa| aa.group_by { |bb| [bb[:kode_program], bb[:nama_program]] } }
    opd_programs.transform_values { |oopds| oopds.transform_values { |values| sum_pagu(values) } }
  end

  def all_subkegiatans
    tematik_childs.map do |sasaran| # list of Sasaran
      {
        kode_opd: sasaran.opd.kode_unik_opd,
        nama_opd: sasaran.opd.nama_opd,
        kode_subkegiatan: sasaran.program_kegiatan.kode_sub_giat,
        nama_subkegiatan: sasaran.program_kegiatan.nama_subkegiatan,
        pagu: sasaran.total_anggaran.to_i
      }
    end
  end

  def subkegiatan_with_pagu
    opds = all_subkegiatans.group_by { |opd| [opd[:kode_opd], opd[:nama_opd]] }
    opd_programs = opds.transform_values { |aa| aa.group_by { |bb| [bb[:kode_subkegiatan], bb[:nama_subkegiatan]] } }
    opd_programs.transform_values { |oopds| oopds.transform_values { |values| sum_pagu(values) } }
  end

  def total
    sum_pagu(all_programs)
  end

  def total_sub
    sum_pagu(all_subkegiatans)
  end

  def sum_pagu(programs)
    programs.map { |pr| pr[:pagu] }
            .inject(:+)
  end

  def child_of_childs(childs)
    childs.childs
  end

  def get_childs(childs)
    childs.map { |aa| aa.respond_to?(:childs) ? get_childs(child_of_childs(aa)) : aa }
  end
end
