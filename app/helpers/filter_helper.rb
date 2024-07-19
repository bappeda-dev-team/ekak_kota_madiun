module FilterHelper
  def dropdown_opd(all: nil)
    kota = ['Kota Madiun', 'all'] if all
    opds = Opd.includes(:lembaga).where(lembagas: { id: current_user.opd.lembaga_id })
    if current_user.has_role?(:super_admin) || current_user.has_role?(:reviewer) || current_user.nik == 'bapelitbangda'
      options_for_select(opds.collect do |o|
                           [o.nama_lembaga_opd, o.kode_unik_opd]
                         end.prepend(kota), cookies[:opd])
    elsif current_user.nik == 'rsud2022'
      options_for_select(opds.rewhere(kode_opd: 1270).pluck(:nama_opd, :kode_unik_opd),
                         current_user.opd.kode_unik_opd)
    elsif current_user.nik == 'bagianpemerintahan'
      options_for_select(opds.rewhere(kode_opd: 1380).pluck(:nama_opd, :kode_unik_opd),
                         current_user.opd.kode_unik_opd)
    elsif current_user.nik == 'bagianorganisasi'
      options_for_select(opds.rewhere(kode_opd: 1349).pluck(:nama_opd, :kode_unik_opd),
                         current_user.opd.kode_unik_opd)
    elsif current_user.nik == 'bagianumum'
      options_for_select(opds.rewhere(kode_opd: 1351).pluck(:nama_opd, :kode_unik_opd),
                         current_user.opd.kode_unik_opd)
    elsif current_user.nik == 'bagianhukum'
      options_for_select(opds.rewhere(kode_opd: 1350).pluck(:nama_opd, :kode_unik_opd),
                         current_user.opd.kode_unik_opd)
    elsif current_user.nik == 'perekokesra'
      options_for_select(opds.rewhere(kode_opd: 1382).pluck(:nama_opd, :kode_unik_opd),
                         current_user.opd.kode_unik_opd)
    elsif current_user.nik == 'adbang'
      options_for_select(opds.rewhere(kode_opd: 1172).pluck(:nama_opd, :kode_unik_opd),
                         current_user.opd.kode_unik_opd)
    else
      options_for_select(
        opds
          .rewhere(kode_opd: current_user.kode_opd)
          .where.not(kode_opd: nil)
          .pluck(:nama_opd, :kode_unik_opd), current_user.opd.kode_unik_opd
      )
    end
  end
end
