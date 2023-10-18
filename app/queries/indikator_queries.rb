class IndikatorQueries
  attr_accessor :tahun, :opd, :program_kegiatan

  def initialize(tahun: '', opd: nil, program_kegiatan: nil)
    @tahun = tahun
    @opd = opd
    @program_kegiatan = program_kegiatan
  end

  def kode_program
    @program_kegiatan.kode_program
  end

  def kode_kegiatan
    @program_kegiatan.kode_giat
  end

  def kode_subkegiatan
    @program_kegiatan.kode_sub_giat
  end

  def kode_opd
    @program_kegiatan&.opd&.kode_unik_opd || @program_kegiatan.kode_sub_skpd
  end

  def tahun_bener
    @tahun.include?('perubahan') ? @tahun[/[^_]\d*/, 0] : @tahun
  end

  def indikator_program
    indikators = Indikator.where(kode: kode_program,
                                 tahun: tahun_bener,
                                 sub_jenis: 'Program',
                                 jenis: 'Renstra',
                                 kode_opd: kode_opd)
                          .order(version: :desc)
    indikator = indikators.first
    {
      indikator: indikator.indikator,
      target: indikator.target,
      satuan: indikator.satuan
    }
  rescue StandardError
    {
      indikator: '',
      target: '',
      satuan: ''
    }
  end

  def indikator_kegiatan
    indikators = Indikator.where(kode: kode_kegiatan,
                                 tahun: tahun_bener,
                                 sub_jenis: 'Kegiatan',
                                 jenis: 'Renstra',
                                 kode_opd: kode_opd)
                          .order(version: :desc)
    indikator = indikators.first
    {
      indikator: indikator.indikator,
      target: indikator.target,
      satuan: indikator.satuan
    }
  rescue StandardError
    {
      indikator: '',
      target: '',
      satuan: ''
    }
  end

  def indikator_subkegiatan
    indikators = Indikator.where(kode: kode_subkegiatan,
                                 tahun: tahun_bener,
                                 sub_jenis: 'Subkegiatan',
                                 jenis: 'Renstra',
                                 kode_opd: kode_opd)
                          .order(version: :desc)
    indikator = indikators.first
    {
      indikator: indikator.indikator,
      target: indikator.target,
      satuan: indikator.satuan
    }
  rescue StandardError
    {
      indikator: '',
      target: '',
      satuan: ''
    }
  end
end
