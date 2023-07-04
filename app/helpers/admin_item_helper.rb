module AdminItemHelper
  def perencanaan_items # rubocop:disable Metrics/MethodLength
    [
      {
        title: 'Usulan', href: "#",
        multi: true, collections: usulan_users,
        id_target: 'perencanaan-usulan',
        collapse_items: collapsed_item_usulan_user,
        icon: 'fas fa-book', identifier: 'usulans'
      },
      {
        title: 'Pohon Kinerja', href: pohon_kinerja_index_path,
        icon: 'fas fa-tree', identifier: 'pohon_kinerja/asn'
      },
      {
        title: 'Cascading', href: asn_pohon_kinerja_index_path,
        icon: 'fas fa-tree', identifier: 'pohon_kinerja/asn'
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
      },
      {
        title: 'SPBE', href: index_opd_spbes_path,
        icon: 'fas fa-tablet-alt', identifier: 'spbe_opd'
      }
    ]
  end

  def collapsed_perencanaan_items
    collapse_class('(' \
                   '\busulan_inisiatif|\busulan_musrenbang|' \
                   '\busulan_pokpir|\busulan_mandatori|' \
                   '\bpohon_kinerja/asn|' \
                   '\brencana_kinerja|\brincian_belanja|' \
                   '\bsasaran_program_opds/daftar_resiko|)')
  end

  def laporan_items # rubocop:disable Metrics/MethodLength
    [
      {
        title: 'Usulan', href: "#",
        multi: true, collections: laporan_usulans,
        id_target: 'laporan-usulans',
        collapse_items: collapsed_laporan_usulan_items,
        icon: 'fas fa-book', identifier: 'usulans'
      },
      {
        title: 'Rekap Pohon Kinerja', href: rekap_opd_pohon_kinerja_index_path,
        icon: 'fas fa-tree', identifier: 'pohon_kinerja/rekap'
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
        collapse_items: collapsed_renja_items,
        icon: 'fas fa-tasks', identifier: 'renja'
      }
    ]
  end

  def collapsed_laporan_items
    collapse_class('(' \
                   '\blaporans\/laporan_usulan|\blaporans\/laporan_pohon|' \
                   '\blaporans\/laporan_kak|\blaporans\/laporan_rka|' \
                   '\brenstra|\brenja\/ranwal|' \
                   '\brenja\/rankir|\brenja\/penetapan|)')
  end

  def perencanaan_opd_items
    [
      {
        title: 'Tujuan OPD', href: tujuan_opds_path,
        icon: 'fas fa-city', identifier: 'tujuan_opds'
      },
      {
        title: 'Isu Strategis OPD', href: isu_strategis_opds_path,
        icon: 'fas fa-bullseye', identifier: 'isu_strategis_opds'
      },
      {
        title: 'Pohon Kinerja', href: pohon_kinerja_index_path,
        icon: 'fas fa-tree', identifier: 'pohon_kinerja'
      },
      {
        title: 'Cascading', href: opd_pohon_kinerja_index_path,
        icon: 'fas fa-tree', identifier: 'pohon_kinerja/opd'
      },
      # { title: 'Sasaran OPD', href: sasaran_opds_path, identifier: 'opds/sasaran' },
      # { title: 'Kotak Usulan OPD', href: kotak_usulan_opds_path,
      #   identifier: 'opds/kotak_usulan' },
      {
        title: 'Info OPD', href: info_opds_path,
        icon: 'fas fa-building', identifier: 'opds/info'
      },
      {
        title: 'SPBE', href: index_opd_spbes_path,
        icon: 'fas fa-tablet-alt', identifier: 'spbe_opd'
      }
    ]
  end

  def collapsed_perencanaan_opd_items
    collapse_class('(' \
                   '\btujuan_opds|\bisu_strategis_opds|' \
                   '\bstrategi_opds|\bsasaran_opds|' \
                   '\bpohon_kinerja|' \
                   '\bpohon_kinerja\/opd|' \
                   '\bspbes\/index_opd|' \
                   '\bpohon_kinerja\/rekap_opd|\bopds\/info)')
  end
end
