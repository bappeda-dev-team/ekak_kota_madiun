module AsetsHelper
  def status_aset_value(status_aset)
    status_aset.blank? ? 0 : status_aset
  end
end
