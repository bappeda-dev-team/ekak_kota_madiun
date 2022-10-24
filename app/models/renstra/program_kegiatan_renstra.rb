class Renstra::ProgramKegiatanRenstra
  include Renstra::OpdKhusus

  def initialize(kode:, tahun:, jenis:, tipe:)
    @kode = kode
    @tahun = tahun
    @jenis = jenis
    @tipe = tipe
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

  def indikator_programs_opd(opd:, program_kegiatans_by_opd:)
    program_kegiatans_by_opd.map do |program|
      program_renstra_serializer(program: program)
    end
  end

  def program_kota(jenis_program_kegiatan:)
    all_opd.map do |opd|
      programs = indikator_programs_opd(opd: opd, program_kegiatans_by_opd: opd.send(jenis_program_kegiatan))
      if OPD_TABLE.key?(opd.nama_opd.to_sym)
        programs = indikator_programs_opd(opd: opd,
                                          program_kegiatans_by_opd: program_kegiatan_opd_khusus(id_sub_unit: KODE_OPD_BAGIAN[opd.nama_opd.to_sym]))
      end
      {
        opd: opd.nama_opd,
        kode_opd: opd.kode_unik_opd,
        @jenis.to_sym => programs
      }
    end
  end

  def program_renstra_serializer(program:)
    indikators = ind_renstras_new(program: program, sub_unit: program.kode_sub_skpd)
    hasil = {
      jenis: @jenis,
      kode_sub_skpd: program.kode_sub_skpd,
      kode_urusan: program.kode_urusan,
      urusan: program.nama_urusan,
      kode_bidang_urusan: program.kode_bidang_urusan,
      bidang_urusan: program.nama_bidang_urusan,
      nama: program.send("nama_#{@tipe}"),
      kode: program.send("kode_#{@kode}"),
      tahun: @tahun
    }
    case @jenis
    when 'kegiatan'
      hasil.merge!({ program: program.nama_program,
                     kode_program: program.kode_program })
    when 'subkegiatan'
      hasil.merge!({ program: program.nama_program,
                     kode_program: program.kode_program,
                     kegiatan: program.nama_kegiatan,
                     kode_kegiatan: program.kode_giat })
    else
      hasil
    end
    hasil.merge({ jumlah_indikator: indikators.size,
                  indikators: indikators })
  end

  def ind_renstras_new(program:, sub_unit: '')
    indikator_all = program.send("indikator_renstras", sub_unit: sub_unit)
    indikators = indikator_all["indikator_#{@jenis}".to_sym]
    if indikators
      indikators.map do |ind, tahun|
        indikator_serializer(indikator: ind, tahun: tahun)
      end
    else
      []
    end
  end

  def indikator_serializer(indikator:, tahun:)
    { indikator: indikator,
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
end
