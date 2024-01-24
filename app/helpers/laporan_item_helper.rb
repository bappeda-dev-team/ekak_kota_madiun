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

  def substansi_renstra_items
    [
      {
        title: 'Bab 1', href: "#",
        multi: true, collections: bab_1,
        id_target: 'renstra-bab-1',
        icon: 'fas fa-book', identifier: 'bab_1'
      },
      {
        title: 'Bab 2', href: "#",
        multi: true, collections: bab_2,
        id_target: 'renstra-bab-2',
        icon: 'fas fa-book', identifier: 'bab_2'
      },
      {
        title: 'Bab 3', href: "#",
        multi: true, collections: bab_3,
        id_target: 'renstra-bab-3',
        icon: 'fas fa-book', identifier: 'usulans'
      },
      {
        title: 'Bab 4', href: "#",
        multi: true, collections: bab_4,
        id_target: 'renstra-bab-4',
        icon: 'fas fa-book', identifier: 'usulans'
      },
      {
        title: 'Bab 5', href: "#",
        multi: true, collections: bab_5,
        id_target: 'renstra-bab-5',
        icon: 'fas fa-book', identifier: 'usulans'
      },
      {
        title: 'Bab 6', href: "#",
        multi: true, collections: bab_6,
        id_target: 'renstra-bab-6',
        icon: 'fas fa-book', identifier: 'usulans'
      },
      {
        title: 'Bab 7', href: "#",
        multi: true, collections: bab_7,
        id_target: 'renstra-bab-7',
        icon: 'fas fa-book', identifier: 'usulans'
      }
    ]
  end

  def bab_1
    [
      {
        title: 'Dasar Hukum', href: spip_index_path,
        icon: 'fas fa-chalkboard', identifier: 'spip'
      }
    ]
  end

  def bab_2
    [
      {
        title: 'Evaluasi Renstra', href: spip_index_path,
        icon: 'fas fa-chalkboard', identifier: 'spip'
      }
    ]
  end

  def bab_3
    [
      {
        title: 'Permasalahan dan Isu Strategis', href: spip_index_path,
        identifier: 'spip'
      },
      {
        title: 'Pohon Kinerja', href: spip_index_path,
        identifier: 'spip'
      }
    ]
  end

  def bab_4
    [
      {
        title: 'Tujuan dan Sasaran', href: spip_index_path,
        identifier: 'spip'
      },
      {
        title: 'Pohon Cascading', href: spip_index_path,
        identifier: 'spip'
      }
    ]
  end

  def bab_5
    [
      {
        title: 'Strategi dan Arah Kebijakan', href: spip_index_path,
        identifier: 'spip'
      }
    ]
  end

  def bab_6
    [
      {
        title: 'Matriks Renstra', href: spip_index_path,
        identifier: 'spip'
      }
    ]
  end

  def bab_7
    [
      {
        title: 'Indikator', href: "#",
        multi: true, collections: laporan_indikators,
        id_target: 'substansi-renstra-indikator',
        identifier: 'usulans'
      }
    ]
  end
end
