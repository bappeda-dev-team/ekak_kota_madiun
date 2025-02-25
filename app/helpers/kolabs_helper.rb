module KolabsHelper
  def bisa_pilih_kolab?(opd)
    admin_kota? || current_user.opd == opd
  end
end
