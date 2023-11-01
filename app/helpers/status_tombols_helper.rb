module StatusTombolsHelper
  def button_disabled?(*args)
    kode, kode_opd, tahun = args
    status = StatusTombol.find_by(
      kode_tombol: kode,
      kode_opd: kode_opd,
      tahun: tahun
    )
    if status.nil?
      false
    else
      status.disabled
    end
  end
end
