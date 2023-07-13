module AdminItemHelper
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
        title: 'Peta Rencana SPBE', href: index_opd_spbes_path,
        icon: 'fas fa-tablet-alt', identifier: 'spbe_opd'
      },
      {
        title: 'SPIP', href: spip_index_path,
        icon: 'fas fa-chalkboard', identifier: 'spip'
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
