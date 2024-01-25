module Laporans::SubstansiRenstraHelper
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
        title: 'Dasar Hukum', href: laporans_substansi_renstra_dasar_hukum_path,
        icon: 'fas fa-chalkboard', identifier: 'substansi-renstra-bab-1-dasar-hukum'
      }
    ]
  end

  def bab_2
    [
      {
        title: 'Evaluasi Renstra', href: laporans_substansi_renstra_evaluasi_renstra_path(periode: '2019-2024'),
        icon: 'fas fa-chalkboard', identifier: 'substansi-renstra-bab-2-evaluasi-renstra'
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
