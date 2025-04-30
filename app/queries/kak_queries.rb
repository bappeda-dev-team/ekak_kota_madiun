class KakQueries
  extend Memoist

  attr_accessor :tahun, :opd, :user

  def initialize(tahun: '', opd: nil, user: nil)
    @tahun = tahun
    @opd = opd
    @user = user
  end

  def users_eselon4
    if user.nil?
      @opd.users.eselon4
    else
      @opd.users.where(id: user.id)
    end
  end

  def nama_opd
    @opd.nama_opd
  end

  def sasarans
    users_eselon4.map do |user|
      user.sasarans.includes(%i[indikator_sasarans]).where(tahun: @tahun, keterangan: nil)
    end.flatten
  end

  def sasarans_eselon4
    users_eselon4.map do |user|
      user.sasarans.includes(%i[indikator_sasarans]).where(tahun: @tahun, keterangan: nil)
          .select { |ss| ss.strategi&.role == 'eselon_4' }
    end.flatten
  end

  def filter_sasaran
    sasarans.select(&:strategi)
  end

  def sasaran_strategis
    filter_sasaran.reject { |s| s.strategi.type == 'StrategiPohon' }
  end

  def program_kegiatans
    sasaran_strategis.group_by(&:program_kegiatan).to_h
  end

  def pk_sasarans
    sasarans_eselon4.group_by(&:program_kegiatan)
                    .sort_by { |pk, _| pk.nil? ? [] : pk.values_at(:kode_sub_giat) }
                    .to_h
  end

  def sasarans_program_kegiatans
    users_eselon4.map do |user|
      user.sasarans.includes(%i[program_kegiatan]).where(tahun: @tahun, keterangan: nil)
          .where.not(program_kegiatan_id: nil)
    end.flatten
  end

  def pk_with_pagu
    pks = sasarans_program_kegiatans.group_by do |sas|
      { kode: sas.program_kegiatan.kode_sub_fix_sipd,
        nama: sas.program_kegiatan.nama_subkegiatan }
    end

    pks_transformer(pks)
  end

  def by_subkegiatan(sasarans)
    sasarans.group_by(&:program_kegiatan)
  end

  private

  def anggaran_sasarans(sasarans)
    sasarans.flat_map { |s| s.anggarans.includes(:rekening) }
  end

  # transform program_kegiatan => sasarans
  # into {kode: pk.kode, nama: pk.nama} => anggarans
  def pks_transformer(pks)
    pk_anggs = pks.transform_values { |ss| anggaran_sasarans(ss) }

    pk_anggs.to_h do |pk, ss|
      key = {
        kode: pk[:kode],
        nama: pk[:nama],
        angg: ss.flat_map(&:jumlah).compact.sum
      }
      [key, ss]
    end
  end
end
