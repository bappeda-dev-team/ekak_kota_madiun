module PohonKinerjaHelper
  def nama_eselon(eselon)
    case eselon
    when 'eselon_2'
      'level_1'
    when 'eselon_3'
      'level_2'
    when 'eselon_4'
      'level_3'
    else
      'level_4'
    end
  end
end
