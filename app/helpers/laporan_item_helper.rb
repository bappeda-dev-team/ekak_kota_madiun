module LaporanItemHelper
  def laporan_items
    [
      {
        title: 'Usulan', href: "#",
        multi: true, collections: laporan_usulans,
        id_target: 'laporan-usulans',
        icon: 'fas fa-book', identifier: 'usulans'
      },
      {
        title: 'SPIP', href: spip_index_path,
        icon: 'fas fa-chalkboard', identifier: 'spip'
      },
      {
        title: 'Gender', href: genders_path,
        icon: 'fas fa-people-carry', identifier: 'gap'
      },
      {
        title: 'Cascading Kota', href: hasil_cascading_kota_laporans_path,
        icon: 'fas fa-people-arrows', identifier: 'hasil_cascading_kota'
      },
      {
        title: 'Cascading Opd', href: hasil_cascading_laporans_path,
        icon: 'fas fa-people-arrows', identifier: 'hasil_cascading'
      },
      {
        title: 'Rencana Kinerja (KAK)', href: laporan_kak_laporans_path,
        icon: 'fas fa-bullseye', identifier: 'laporan_kak'
      },
      {
        title: 'Rincian Belanja', href: laporan_rka_laporans_path,
        icon: 'fas fa-money-check', identifier: 'laporan_rka'
      },
      {
        title: 'Renstra', href: renstra_index_path,
        icon: 'fas fa-stream', identifier: 'renstra'
      },
      {
        title: 'Renja', href: "#",
        multi: true, collections: renja_items,
        id_target: 'renja-items',
        icon: 'fas fa-tasks', identifier: 'renja'
      },
      {
        title: 'Renja Perubahan', href: renja_perubahan_path,
        icon: 'fas fa-archive', identifier: 'perubahan_renja'
      },
      {
        title: 'Rekap Rencana Kinerja', href: rekap_sasaran_sasarans_path,
        icon: 'fas fa-archive', identifier: 'rekap_sasaran'
      },
      {
        title: 'Rekap Strategi', href: rekap_strategi_strategis_path,
        icon: 'fas fa-archive', identifier: 'rekap_strategi'
      },
      {
        title: 'Rekap Cascading', href: list_pohon_pohon_kinerja_index_path,
        icon: 'fas fa-archive', identifier: 'rekap_cascading'
      }
    ]
  end
end
