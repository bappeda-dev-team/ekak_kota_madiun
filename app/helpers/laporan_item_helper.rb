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
        title: 'Indikator Opd', href: "#",
        multi: true, collections: laporan_indikators,
        id_target: 'indikator-opd',
        icon: 'fas fa-book', identifier: 'usulans'
      },
      {
        title: 'SPIP', href: spip_index_path,
        icon: 'fas fa-chalkboard', identifier: 'spip'
      },
      { title: 'Gender', href: laporan_gap_genders_path,
        icon: 'fas fa-people-carry',
        identifier: 'genders/laporan_gap' },
      {
        title: 'Rancangan Peraturan', href: "#",
        multi: true, collections: peraturan_items,
        id_target: 'peraturan-items',
        icon: 'fas fa-book-reader', identifier: 'peraturan'
      },
      { title: 'Inovasi Sasaran Kinerja', href: inovasi_sasaran_kinerja_laporans_path,
        icon: 'fas fa-book-open',
        identifier: 'laporan-inovasi-sasaran-kinerja' },
      { title: 'Sasaran Penduduk', href: sasaran_penduduk_laporans_path,
        icon: 'fas fa-book-open',
        identifier: 'laporan-sasaran-kemiskinan' }
      # {
      #   title: 'Gender', href: "#",
      #   multi: true, collections: gender_items,
      #   id_target: 'gender-items',
      #   icon: 'fas fa-people-carry', identifier: 'genders'
      # },
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
        title: 'Renstra', href: "#",
        multi: true, collections: renstra_items,
        id_target: 'renstra-items',
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

  def laporan_indikators
    [
      { title: 'RB', href: indikator_rb_laporans_path, identifier: 'laporan_indikator_rb' },
      { title: 'LPPD', href: indikator_lppd_laporans_path, identifier: 'laporan_indikator_lppd' },
      { title: 'SPM', href: indikator_spm_laporans_path, identifier: 'laporan_indikator_spm' },
      { title: 'SDGs', href: indikator_sdgs_laporans_path, identifier: 'laporan_indikator_sdgs' }
    ]
  end

  def peraturan_items
    [
      { title: 'Perda', href: output_raperda_laporans_path,
        icon: 'fas fa-book-open',
        identifier: 'laporan-output-raperda' },
      { title: 'Perwal', href: output_perwal_laporans_path,
        icon: 'fas fa-book-open',
        identifier: 'laporan-output-raperda' },
      { title: 'SK Walikota', href: output_sk_walikota_laporans_path,
        icon: 'fas fa-book-open',
        identifier: 'laporan-output-raperda' }
    ]
  end
end
