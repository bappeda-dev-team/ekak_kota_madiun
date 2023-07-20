module SpipHelper
  def kosong_class(condition)
    if condition
      'bg-danger text-white'
    else
      ''
    end
  end
end
