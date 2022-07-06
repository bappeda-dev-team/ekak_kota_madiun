class Rekap
  attr_accessor :kode_unik_opd

  def initialize(kode_unik_opd:)
    @kode_unik_opd = kode_unik_opd
  end

  def jumlah_rekap
    # Musrenbang
    opd.program_kegiatans.map { |p| p.sasarans.map(&:usulans).compact_blank }.compact_blank
    # Pokpir
    # opd.program_kegiatans.map { |p| p.usulans.where(usulanable: 'Pokpir').count }.compact.count
    # Mandatori
    # opd.program_kegiatans.map { |p| p.usulans.where(usulanable: 'Mandatori').count }.compact.count
    # Insisiatif Walikota
    # opd.program_kegiatans.map { |p| p.usulans.where(usulanable: 'Inisiatif').count }.compact.count

    # Spawn jumlah usulan ( musren, pokpir, mandatori, inovasi )
    # spawn jumlah sasaran kinerja
    # spawn jumlah sub kegiatan yang diambil
    # spawn jumlah kegiatan yang diambil
    # spawn jumlah program yang diambil
    # spawn jumlah anggaran
    # spawn jumlah eselon 4
    # spawn jumlah eselon 3
  end

  def opd
    Opd.find_by(kode_unik_opd: kode_unik_opd)
  end
end
