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
      user.sasarans.includes(:strategi).where(tahun: @tahun, keterangan: nil)
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

  def by_subkegiatan(sasarans)
    sasarans.group_by(&:program_kegiatan)
  end
end
