# KakService(tahun: 2022, kode_unik_opd: '5.01.01.xx', program_kegiatan: optional)
# used for get pk by opd, sasarans by user on opd selected
# compatible with tahun kelompok_anggaran
class KakService
  OPD_TABLE = {
    'Dinas Kesehatan, Pengendalian Penduduk dan Keluarga Berencana': "Dinas Kesehatan",
    'Rumah Sakit Umum Daerah Kota Madiun': "Rumah Sakit Umum Daerah",
    'Sekretariat Daerah': "Sekretaris Daerah",
    'Bagian Umum': "Bagian Umum",
    'Bagian Pengadaan Barang/Jasa dan Administrasi Pembangunan': "Bagian Pengadaan Barang/Jasa dan Administrasi Pembangunan",
    'Bagian Organisasi': "Bagian Organisasi",
    'Bagian Hukum': "Bagian Hukum",
    'Bagian Perekonomian dan Kesejahteraan Rakyat': "Bagian Perekonomian dan Kesejahteraan Rakyat",
    'Bagian Pemerintahan': "Bagian Pemerintahan"
  }.freeze

  KODE_OPD_TABLE = {
    'Dinas Kesehatan, Pengendalian Penduduk dan Keluarga Berencana': "1.02.2.14.0.00.03.0000",
    'Rumah Sakit Umum Daerah Kota Madiun': "1.02.2.14.0.00.03.0000",
    'Sekretariat Daerah': "4.01.0.00.0.00.01.00", # don't change, this still used
    'Bagian Umum': "4.01.0.00.0.00.01.00",
    'Bagian Pengadaan Barang/Jasa dan Administrasi Pembangunan': "4.01.0.00.0.00.01.00",
    'Bagian Organisasi': "4.01.0.00.0.00.01.00",
    'Bagian Hukum': "4.01.0.00.0.00.01.00",
    'Bagian Perekonomian dan Kesejahteraan Rakyat': "4.01.0.00.0.00.01.00",
    'Bagian Pemerintahan': "4.01.0.00.0.00.01.00"
  }.freeze

  KODE_OPD_BAGIAN = {
    'Dinas Kesehatan, Pengendalian Penduduk dan Keluarga Berencana': "448",
    'Rumah Sakit Umum Daerah Kota Madiun': "3408",
    'Sekretariat Daerah': "479", # don't change, this still used
    'Bagian Umum': "4402",
    'Bagian Pengadaan Barang/Jasa dan Administrasi Pembangunan': "4400",
    'Bagian Organisasi': "4398",
    'Bagian Hukum': "4399",
    'Bagian Perekonomian dan Kesejahteraan Rakyat': "4401",
    'Bagian Pemerintahan': "4397"
  }.freeze
  attr_reader :kode_unik_opd, :program_kegiatan

  def initialize(tahun:, kode_unik_opd: nil, program_kegiatan: nil)
    @kode_unik_opd = kode_unik_opd
    @program_kegiatan = program_kegiatan
    @tahun = tahun.to_s
  end

  def tahun
    @tahun = @tahun.match(/murni/) ? @tahun[/[^_]\d*/, 0] : @tahun
  end

  def sasarans_filter(tahun_sasaran, sasarans)
    if tahun.match(/(_)/)
      sasarans.sudah_lengkap.select { |s| s.tahun == tahun_sasaran }
    else
      sasarans.sudah_lengkap.reject { |s| s.tahun&.match?(/(_)/) }
    end
  end

  def laporan_rencana_kinerja
    program_kegiatans_by_opd.map do |pk|
      sasarans_filter(@tahun, pk.sasarans)
    end.compact_blank!.flatten.group_by(&:program_kegiatan)
  end

  def sasarans_by_user
    asn_aktif_by_opd.map do |user_aktif|
      { user_aktif => sasarans_filter(@tahun, user_sasarans(user_aktif)).group_by(&:program_kegiatan) }
    end
  end

  def user_sasarans(users)
    users.sasarans.dengan_sub_kegiatan
  end

  def program_kegiatans_by_opd
    opd.program_kegiatans
  end

  def asn_aktif_by_opd
    opd.users.asn_aktif
  end

  def isu_strategis
    all_isu = program_kegiatans_by_opd.order(:kode_program).map do |pk|
      {
        nama_program: pk.nama_program,
        kode_program: pk.kode_program,
        indikator: pk.indikator_program,
        target: pk.target_program,
        satuan: pk.satuan_target_program,
        subkegiatan: pk.nama_subkegiatan,
        indikator_sub: pk.indikator_subkegiatan,
        target_sub: pk.target_subkegiatan,
        satuan_sub: pk.satuan_target_subkegiatan,
        isu_strategis: pk.isu_strategis,
        permasalahans: pk.permasalahans.map(&:permasalahan)
      }
    end
    all_isu.group_by { |key, _value| key[:kode_program] }
  end

  def indikator_programs_opd(jenis:, kode:, nama:)
    programs = program_kegiatans_by_opd.map do |program|
      indikators = indikator_renstra(jenis, program)
      {
        opd: opd.nama_opd,
        kode_opd: program.kode_sub_skpd,
        kode_urusan: program.kode_urusan,
        urusan: program.nama_urusan,
        kode_bidang_urusan: program.kode_bidang_urusan,
        bidang_urusan: program.nama_bidang_urusan,
        nama: program.send("nama_#{nama}"),
        kode: program.send("kode_#{kode}"),
        indikators: indikators,
        tahun: @tahun
      }
    end
    programs.uniq { |item| item[:kode] }
  end

  def indikator_renstra_programs_opd(jenis:, kode:, nama:)
    programs = program_kegiatans_by_opd.map do |program|
      indikators = ind_renstras_new(jenis, program)
      {
        opd: opd.nama_opd,
        kode_opd: program.kode_sub_skpd,
        kode_urusan: program.kode_urusan,
        urusan: program.nama_urusan,
        kode_bidang_urusan: program.kode_bidang_urusan,
        bidang_urusan: program.nama_bidang_urusan,
        kode_program: program.kode_program,
        kode_kegiatan: program.kode_giat,
        kode_subkegiatan: program.kode_sub_giat,
        nama: program.send("nama_#{nama}"),
        kode: program.send("kode_#{kode}"),
        indikators: indikators,
        tahun: @tahun
      }
    end
    programs.uniq { |item| item[:kode] }
  end

  def ind_renstras_new(jenis, program_kegiatans, sub_unit: '')
    indikator_all = program_kegiatans.send("indikator_renstras", sub_unit: sub_unit)
    indikators = indikator_all["indikator_#{jenis}".to_sym]
    if indikators
      indikators.map do |ind, tahun|
        { indikator: ind,
          indikator_2020: tahun["2020"]&.last&.indikator,
          target_2020: tahun["2020"]&.last&.target,
          satuan_2020: tahun["2020"]&.last&.satuan,
          pagu_2020: tahun["2020"]&.last&.pagu,
          indikator_2021: tahun["2021"]&.last&.indikator,
          target_2021: tahun["2021"]&.last&.target,
          satuan_2021: tahun["2021"]&.last&.satuan,
          pagu_2021: tahun["2021"]&.last&.pagu,
          indikator_2022: tahun["2022"]&.last&.indikator,
          target_2022: tahun["2022"]&.last&.target,
          satuan_2022: tahun["2022"]&.last&.satuan,
          pagu_2022: tahun["2022"]&.last&.pagu,
          indikator_2023: tahun["2023"]&.last&.indikator,
          target_2023: tahun["2023"]&.last&.target,
          satuan_2023: tahun["2023"]&.last&.satuan,
          pagu_2023: tahun["2023"]&.last&.pagu,
          indikator_2024: tahun["2024"]&.last&.indikator,
          target_2024: tahun["2024"]&.last&.target,
          satuan_2024: tahun["2024"]&.last&.satuan,
          pagu_2024: tahun["2024"]&.last&.pagu }
      end
    else
      []
    end
  end

  def indikator_renstra(jenis, program_kegiatans)
    program_kegiatans.send("indikator_#{jenis}_renstra")
                     .map do |pk|
      { id: pk.id, tahun: pk.tahun, kode_indikator: pk.kode_indikator, indikator: pk.indikator, target: pk.target, satuan: pk.satuan,
        pagu: pk.pagu, version: pk.version, kotak: pk.kotak, kode_opd: pk.kode_opd }
    end
  end

  def hash_by_pluck(collections)
    collections.each_with_object({}) do |(key1, key2, key3), result|
      result[key1] ||= {}
      reulst[key1][key2] = key3
    end
  end

  def total_pagu
    laporan_rencana_kinerja.each_value.map { |sasarans| sasarans.map(&:total_anggaran).compact.sum }.inject(:+)
  end

  def total_sasaran_aktif
    sasarans_by_user.map do |collections|
      collections.values.map do |program_kegiatans|
        program_kegiatans.values.map(&:size)
      end
    end.flatten.inject(:+)
  end

  def total_usulan_sasaran(tipe_usulan)
    asn_aktif_by_opd.map do |user_aktif|
      sasarans_filter(@tahun, user_sasarans(user_aktif)).map(&:my_usulan).flatten.filter do |s|
        s.instance_of?(tipe_usulan)
      end.size
    end.inject(:+)
  end

  def total_usulan_musrenbang
    {
      musrenbang: total_usulan_sasaran(Musrenbang),
      pokir: total_usulan_sasaran(Pokpir),
      mandatori: total_usulan_sasaran(Mandatori),
      inisiatif_walikota: total_usulan_sasaran(Inovasi)
    }
  end

  def opd
    @opd ||= Opd.find_by(kode_unik_opd: @kode_unik_opd)
  end

  def all_opd
    lembaga = Lembaga.find_by(nama_lembaga: "Kota Madiun")
    # TODO: beri klausa jika lembaga kosong
    lembaga.opds.where.not(nama_kepala: nil)
  end

  def program_kegiatan_opd_khusus(id_sub_unit:)
    ProgramKegiatan.includes(:opd)
                   .where(id_sub_unit: id_sub_unit)
  end

  def program_kota(jenis:, kode:, nama:)
    all_opd.map do |opd|
      programs = indikator_programs_all_try(jenis: jenis, kode: kode, nama: nama,
                                            program_kegiatans: opd.program_kegiatans)
      if OPD_TABLE.key?(opd.nama_opd.to_sym)
        programs = indikator_programs_all_try(jenis: jenis, kode: kode, nama: nama,
                                              program_kegiatans: program_kegiatan_opd_khusus(id_sub_unit: KODE_OPD_BAGIAN[opd.nama_opd.to_sym]),
                                              sub_unit: KODE_OPD_BAGIAN[opd.nama_opd.to_sym])
      end
      {
        opd: opd.nama_opd,
        kode_opd: opd.kode_unik_opd,
        jenis.to_sym => programs
      }
    end
  end

  def indikator_programs_all_try(jenis:, kode:, nama:, program_kegiatans:, sub_unit: '')
    programs = program_kegiatans.map do |program|
      indikators = ind_renstras_new(jenis, program, sub_unit: sub_unit)
      hasil = {
        kode_urusan: program.kode_urusan,
        urusan: program.nama_urusan,
        kode_bidang_urusan: program.kode_bidang_urusan,
        bidang_urusan: program.nama_bidang_urusan,
        nama: program.send("nama_#{nama}"),
        kode: program.send("kode_#{kode}"),
        indikators: indikators,
        tahun: @tahun
      }
      if jenis == 'kegiatan'
        hasil.merge({ program: program.nama_program,
                      kode_program: program.kode_program })
      elsif jenis == 'subkegiatan'
        hasil.merge({ program: program.nama_program,
                      kode_program: program.kode_program,
                      kegiatan: program.nama_kegiatan,
                      kode_kegiatan: program.kode_giat })
      else
        hasil
      end
    end
    programs.uniq { |item| item[:kode] }
  end
end
