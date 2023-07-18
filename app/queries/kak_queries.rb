class KakQueries
  extend Memoist

  attr_accessor :tahun, :opd

  def initialize(tahun: '', opd: nil)
    @tahun = tahun
    @opd = opd
  end

  def users_eselon4
    @opd.users.eselon4
  end

  def nama_opd
    @opd.nama_opd
  end

  def sasarans
    users_eselon4.map do |user|
      user.sasarans.where(tahun: @tahun)
    end
  end

  def program_kegiatans
    sasarans.flatten.group_by(&:program_kegiatan)
  end
end
