module PohonKinerjaHelper
  def nama_eselon(eselon)
    case eselon
    when 'eselon_2'
      'level_1'
    when 'eselon_2b'
      'level_1b'
    when 'eselon_3'
      'level_2'
    when 'eselon_4'
      'level_3'
    else
      'level_4'
    end
  end

  def opd_khusus?(opd_id)
    [145, 122].include?(opd_id)
  end

  def role_opd_khusus(opd_id)
    if [145, 122].include?(opd_id)
      %w[eselon_2b eselon_3]
    else
      'eselon_3'
    end
  end
end
