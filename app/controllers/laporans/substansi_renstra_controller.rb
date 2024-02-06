class Laporans::SubstansiRenstraController < ApplicationController
  def dasar_hukum
    @kode_opd = cookies[:opd]
    @tahun = cookies[:tahun]
    @opd = Opd.find_by(kode_unik_opd: @kode_opd)

    @dasar_hukums = @opd.sasarans
                        .includes(%i[strategi
                                     user
                                     usulans
                                     mandatoris
                                     program_kegiatan
                                     indikator_sasarans])
                        .order(nip_asn: :asc)
                        .dengan_strategi
                        .flat_map(&:mandatoris)
                        .select { |mandatori| mandatori.tahun == @tahun }
  end

  def evaluasi_renstra
    periode = params[:periode].split('-')
    @tahun_awal = periode[0].to_i
    @tahun_akhir = periode[-1].to_i
    @periode = (@tahun_awal..@tahun_akhir)
    @colspan = (@periode.size * 5) + 3
    @kode_opd = cookies[:opd]
    @opd = Opd.find_by(kode_unik_opd: @kode_opd)
    @nama_opd = @opd.nama_opd
    program_renstra = @opd.program_renstra

    program_kegiatan_by_urusans = program_renstra.group_by do |prg|
      [prg.kode_urusan, prg.nama_urusan]
    end
    @program_kegiatans = program_kegiatan_by_urusans.transform_values do |prg_v1|
      prg_v1.group_by { |prg| [prg.kode_bidang_urusan, prg.nama_bidang_urusan] }
    end
  end

  def permasalahan_isu_strategis
    @kode_unik_opd = cookies[:opd]
    @tahun = cookies[:tahun]
    @opd = Opd.find_by(kode_unik_opd: @kode_unik_opd)
    @nama_opd = @opd.nama_opd
    tahun_asli = @tahun.include?('perubahan') ? @tahun.gsub('_perubahan', '') : @tahun
    tahun_awal = 2019
    tahun_akhir = 2023
    @range_tahun = tahun_akhir.downto(tahun_awal).to_a
    @isu_strategis = @opd.isu_strategis_opds
                         .where("tahun ILIKE ?", "%#{tahun_asli}%")
                         .order(:id).group_by { |isu| "(#{isu.kode_bidang_urusan}) #{isu.bidang_urusan}" }
  end

  def pohon_kinerja
    @tahun = cookies[:tahun]
    @kode_opd = cookies[:opd]
    queries = PohonKinerjaOpdQueries.new(tahun: @tahun, kode_opd: @kode_opd)
    @opd = queries.opd
    @nama_opd = @opd.nama_opd

    @strategi_kota = queries.strategi_kota.reject { |ph| ph.pohonable.nil? }
    @tactical_kota = queries.tactical_kota
    @operational_kota = queries.operational_kota

    @strategi_opd = queries.strategi_opd
    @tactical_opd = queries.tactical_opd
    @operational_opd = queries.operational_opd
    @staff_opd = queries.staff_opd

    return if @tahun.nil?

    # TODO: extract to ajax
    tahun_bener = @tahun.match(/murni|perubahan/) ? @tahun[/[^_]\d*/, 0] : @tahun
    @tahun_awal = 2019
    @tahun_akhir = 2023
    @tujuan_opds = @opd.tujuan_opds.includes(%i[indikators urusan])
                       .by_periode(tahun_bener)
  end

  def tujuan_dan_sasaran
    @tahun = cookies[:tahun]
    @kode_opd = cookies[:opd]
    strategi_arah_kebijakan = StrategiArahKebijakan.new(tahun: @tahun, kode_opd: @kode_opd)
    @opd = strategi_arah_kebijakan.opd
    @strategi_opds = strategi_arah_kebijakan.tujuan_strategi_opds
  end

  def pohon_cascading; end

  def strategi_arah_kebijakan
    @tahun = cookies[:tahun]
    @kode_opd = cookies[:opd]
    strategi_arah_kebijakan = StrategiArahKebijakan.new(tahun: @tahun, kode_opd: @kode_opd)
    @opd = strategi_arah_kebijakan.opd
    @tujuan_opds = strategi_arah_kebijakan.tujuan_opds
    @strategi_opds = strategi_arah_kebijakan.tujuan_strategi_opds
    @tactical_opds = strategi_arah_kebijakan.tactical_opds
    @isu_strategis_opds = strategi_arah_kebijakan.isu_strategis_opds
  end

  def matrik_renstra
    periode = params[:periode].split('-')
    @tahun_awal = periode[0].to_i
    @tahun_akhir = periode[-1].to_i
    @periode = (@tahun_awal..@tahun_akhir)
    @colspan = (@periode.size * 5) + 3
    @kode_opd = cookies[:opd]
    @opd = Opd.find_by(kode_unik_opd: @kode_opd)
    @nama_opd = @opd.nama_opd
    program_renstra = @opd.program_renstra

    @list_subkegiatans = @periode.map { |tahun| @opd.sasaran_subkegiatans(tahun) }.flatten
    program_kegiatan_by_urusans = program_renstra.group_by do |prg|
      [prg.kode_urusan, prg.nama_urusan]
    end
    @program_kegiatans = program_kegiatan_by_urusans.transform_values do |prg_v1|
      prg_v1.group_by { |prg| [prg.kode_bidang_urusan, prg.nama_bidang_urusan] }
    end
  end
end
