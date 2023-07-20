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
      user.sasarans.where(tahun: @tahun)
    end.flatten
  end

  def program_kegiatans
    sasarans.group_by(&:program_kegiatan)
  end
end
