module ReviewerItemHelper
  def reviewer_items
    [
      {
        title: 'Pohon Kinerja Kota', href: kota_pohon_kinerja_index_path,
        icon: 'fas fa-tree', identifier: 'pohon_kinerja/kota'
      },
      {
        title: 'Pohon Kinerja OPD', href: pohon_kinerja_opds_path,
        icon: 'fas fa-tree', identifier: 'pohon_kinerja'
      },
      {
        title: 'Pohon Cascading', href: cascading_pohon_kinerja_opds_path,
        icon: 'fas fa-tree', identifier: 'pohon_kinerja'
      }
    ]
  end

  def laporan_reviewer_items
    [
      {
        title: 'Cascading Kota', href: hasil_cascading_kota_laporans_path,
        icon: 'fas fa-people-arrows', identifier: 'hasil_cascading_kota'
      },
      {
        title: 'Cascading OPD', href: hasil_cascading_laporans_path,
        icon: 'fas fa-people-arrows', identifier: 'hasil_cascading'
      },
      {
        title: 'Sasaran Kota / RAD', href: sasaran_kota_path,
        icon: 'fas fa-bullseye', identifier: 'sasaran_kota'
      },
      {
        title: 'Manajemen Risiko', href: daftar_resiko_laporans_path,
        icon: 'fas fa-chart-line', identifier: 'sasaran_program_opds/daftar_resiko'
      }
    ]
  end
end
