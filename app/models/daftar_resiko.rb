# handle daftar resiko for admin and asn
class DaftarResiko
  def initialize(tahun:, kode_unik_opd: nil)
    @kode_unik_opd = kode_unik_opd
    @tahun = tahun.to_s
  end

  def tanggung_jawab_manrisk?(nip: '')
    user = User.find_by(nik: nip)
    tactical_role = Pohon.where(pohonable_type: 'StrategiPohon',
                                tahun: tahun,
                                role: %w[plt eselon_3],
                                user_id: user.id)
    tactical_role.any?
  end

  def pohon_pelaksana(nip: '')
    user = User.find_by(nik: nip)
    pohon_pelaksana = Pohon.where(pohonable_type: 'StrategiPohon',
                                  tahun: tahun,
                                  role: %w[plt eselon_3],
                                  user_id: user.id)
                           .flat_map(&:pohonable)
    pohon_pelaksana.select { |str| str.opd_id.to_i == opd.id }
  end

  def daftar_resiko_eselon3(nip: '')
    strategis = pohon_pelaksana(nip: nip)
    strategi_bawahans = strategis.flat_map do |strategi|
      strategi.strategi_bawahans.where(tahun: tahun)
    end
    sasaran_bawahans = strategi_bawahans.uniq.flat_map do |str|
      sasarans_filter(tahun, str.sasarans.dengan_sub_kegiatan)
    end
    # altering butuh verif / tidak
    # untuk menampilkan button Edit Dampak
    # atau Verifikasi
    sasaran_bawahans.compact_blank!.flatten.group_by(&:program_kegiatan)
                    .transform_values { |sas| sas.each { |ss| ss.butuh_verifikasi = true } }
  end

  def daftar_resiko_asn(nip: '')
    program_kegiatans_by_opd.with_sasarans_rincian.map do |pk|
      sasarans_asn = pk.sasarans.where(sasarans: { nip_asn: nip })
      sasarans_filter(tahun, sasarans_asn)
    end.compact_blank!.flatten.group_by(&:program_kegiatan)
  end

  def daftar_resiko_plt(nip: '')
    daftar_resiko_eselon3(nip: nip)
    # manrisk_pelaksana = daftar_resiko_asn(nip: nip)

    # verifikasi_list.merge manrisk_pelaksana
  end

  def daftar_resiko_sasaran(sasaran_id: '')
    program_kegiatans_by_opd.with_sasarans_rincian.map do |pk|
      sasarans_asn = pk.sasarans.where(sasarans: { id: sasaran_id })
      sasarans_filter(tahun, sasarans_asn)
    end.compact_blank!.flatten.group_by(&:program_kegiatan)
  end

  def sasarans_filter(tahun_sasaran, sasarans)
    sasarans.dengan_rincian.where(tahun: tahun_sasaran)
            .where.not(nip_asn: [nil, ""])
            .select { |sas| sas.deleted_at.blank? }
  end

  def daftar_resiko_opd
    program_kegiatans_by_opd.with_sasarans_rincian.map do |pk|
      sasarans_filter(tahun, pk.sasarans)
    end.compact_blank!.flatten.group_by(&:program_kegiatan)
  end

  def program_kegiatans_by_opd
    opd.program_kegiatans
  end

  def opd
    kode_opd = if @kode_unik_opd.last == '0'
                 @kode_unik_opd
               else
                 @kode_unik_opd.gsub(/\d$/, '0')
               end

    @opd ||= Opd.find_by(kode_unik_opd: kode_opd)
  end

  def tahun
    @tahun = @tahun.include?('murni') ? @tahun[/[^_]\d*/, 0] : @tahun
  end
end
