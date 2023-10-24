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
    get_childs(strategy_anggaran.childs)
      .flatten
      .select { |chl| chl.program_kegiatan.presence }
  end

  def all_programs
    tematik_childs.map do |go|
      {
        kode_program: go.program_kegiatan.kode_program,
        nama_program: go.program_kegiatan.nama_program,
        pagu: go.total_anggaran.to_i
      }
    end
  end

  def program_with_pagu
    all_programs.group_by { |a| [a[:kode_program], a[:nama_program]] }
                .transform_values { |values| sum_pagu(values) }
                .sort_by { |key, _| key[0] }
  end

  def anggaran
    sum_pagu(all_programs)
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
