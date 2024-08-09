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
                   .where(kode_sub_skpd: id_sub_unit)
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
                                          program_kegiatans_by_opd: program_kegiatan_opd_khusus(id_sub_unit: opd.kode_unik_opd))
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
      nama_sub_skpd: program.nama_opd_pemilik,
      kode_urusan: program.kode_urusan,
      urusan: program.nama_urusan,
      kode_bidang_urusan: program.kode_bidang_urusan,
      bidang_urusan: program.nama_bidang_urusan,
      nama: program.send("nama_#{@tipe}"),
      kode: kode_tweak(program.send("kode_#{@kode}"), @jenis),
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

  def kode_tweak(kode, jenis)
    if kode.scan(/\d+$/).last&.size == 2 && jenis == 'subkegiatan'
      kode.gsub(/[.](?!.*[.])/, ".00\\1")
    else
      kode
    end
  end

  def ind_renstras_new(program:, sub_unit: '')
    indikator_all = program.send("indikator_renstras", sub_unit: sub_unit)
    indikators = indikator_all["indikator_#{@jenis}".to_sym]
    if indikators
      indikators.map do |ind|
        indikator_serializer(indikator: ind)
      end.sort_by { |ind| ind.values_at(:tahun) }
    else
      []
    end
  end

  def indikator_serializer(indikator:)
    {
      id: indikator.id,
      tahun: indikator.tahun,
      indikator: indikator.indikator,
      target: indikator.target,
      satuan: indikator.satuan,
      pagu: indikator.pagu
    }
  end
end
