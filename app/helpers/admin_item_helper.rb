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
        title: 'Pohon Kinerja', href: manual_pohon_kinerja_index_path,
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
        title: 'Manajemen Resiko', href: daftar_resiko_sasaran_program_opds_path,
        icon: 'fas fa-chart-line', identifier: 'sasaran_program_opds/daftar_resiko'
      }
    ]
  end
end
