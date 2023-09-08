module UserItemHelper
  def perencanaan_items # rubocop:disable Metrics/MethodLength
    [
      {
        title: 'Usulan', href: "#",
        multi: true, collections: usulan_users,
        id_target: 'perencanaan-usulan',
        icon: 'fas fa-book', identifier: 'usulans'
      },
      {
        title: 'Pohon Kinerja', href: manual_pohon_kinerja_index_path,
        icon: 'fas fa-tree', identifier: 'pohon_kinerja'
      },
      {
        title: 'Rencana Kinerja', href: sasarans_path,
        icon: 'fas fa-bullseye', identifier: 'rencana_kinerja'
      },
      {
        title: 'Rincian Belanja', href: rincian_belanja_index_path,
        icon: 'fas fa-money-check', identifier: 'rincian_belanja'
      },
      {
        title: 'Manajemen Resiko', href: daftar_resiko_sasaran_program_opds_path,
        icon: 'fas fa-chart-line', identifier: 'sasaran_program_opds/daftar_resiko'
      },
      {
        title: 'Gender', href: gap_genders_path,
        icon: 'fas fa-people-carry', identifier: 'gap'
      }
    ]
  end

  def usulan_users
    [
      { title: 'Musrenbang', href: usulan_musrenbang_path, identifier: 'usulan_musrenbang' },
      { title: 'Pokok Pikiran', href: usulan_pokpir_path, identifier: 'usulan_pokpir' },
      { title: 'Mandatori', href: usulan_mandatori_path, identifier: 'usulan_mandatori' },
      { title: 'Inisiatif Walikota', href: usulan_inisiatif_path, identifier: 'usulan_inisiatif' }
    ]
  end

  def laporan_usulans
    [
      { title: 'Musrenbang', href: '/laporan_usulan/musrenbang', identifier: 'laporan_usulan\/musrenbang' },
      { title: 'Pokok Pikiran', href: '/laporan_usulan/pokpir', identifier: 'laporan_usulan\/pokpir' },
      { title: 'Mandatori', href: '/laporan_usulan/mandatori', identifier: 'laporan_usulan\/mandatori' },
      { title: 'Inisiatif Walikota', href: '/laporan_usulan/inisiatif',
        identifier: 'laporan_usulan\/inisiatif' }
    ]
  end
end
