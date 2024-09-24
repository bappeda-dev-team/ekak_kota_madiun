class TimKerja
  def initialize(kode_opd: '', tahun: '')
    @kode_opd = kode_opd
    @tahun = tahun
  end

  def opd
    @opd ||= Opd.find_by(kode_unik_opd: @kode_opd)
  end

  def strategi_opd
    @strategi_opd ||= opd.strategis.where(type: 'StrategiPohon')
  end

  def tim_kerja_strategi
    strategi_opd.flat_map do |strategi|
      tim_kerja = strategi.pohon_shareds
                          .where.not(role: %w[opd opd-batal], user_id: nil)
                          .order(:user_id)
                          .select { |pelaksana| pelaksana.role_tim.present? }

      { strategi: strategi.to_s,
        tim_kerja: tim_kerja }
    end
  end

  def pelaksana
    tim_kerja_strategi.select { |tim| tim[:tim_kerja].any? }
  end
end
