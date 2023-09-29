module SuperAdminItemHelper
  def super_admin_items # rubocop:disable Metrics/MethodLength
    [
      {
        title: 'Master Usulan', href: "#",
        multi: true, collections: usulan_items,
        id_target: "master-usulan",
        icon: 'fas fa-book-open', identifier: 'usulans'
      },
      {
        title: 'Master Anggaran', href: "#",
        multi: true, collections: anggaran_items,
        id_target: "master-anggaran",
        icon: 'fas fa-coins', identifier: 'anggaran'
      },
      {
        title: 'Master User', href: list_all_users_path,
        icon: 'fas fa-users', identifier: 'list_all'
      },
      {
        title: 'User Khusus', href: khusus_users_path,
        icon: 'fas fa-user-tie', identifier: 'khusus_users'
      },
      {
        title: 'Master OPD', href: all_opd_path,
        icon: 'fas fa-building', identifier: 'list_opd'
      },
      {
        title: 'Master Bidang', href: bidang_opds_path,
        icon: 'fas fa-building', identifier: 'list_opd'
      },
      {
        title: 'Master Rencana Kinerja', href: sasaran_admin_sasarans_path,
        icon: 'fas fa-archive', identifier: 'adminsasarans'
      },
      {
        title: 'Tematik', href: subkegiatan_tematiks_path,
        icon: 'fas fa-tags', identifier: 'tematik'
      },
      {
        title: 'Periode', href: periodes_path,
        icon: 'fas fa-calendar', identifier: 'periode'
      },
      {
        title: 'Tahun', href: tahuns_path,
        icon: 'fas fa-calendar-alt', identifier: 'tahun'
      },
      {
        title: 'Kelompok Anggaran', href: kelompok_anggarans_path,
        icon: 'fas fa-folder', identifier: 'kelompok_anggaran'
      },
      {
        title: 'SPBE', href: "#",
        multi: true, collections: spbe_items,
        id_target: "spbe-item",
        icon: 'fas fa-tablet-alt', identifier: 'spbes'
      },
      {
        title: 'Kriteria Verifikasi', href: kriteria_path,
        icon: 'fas fa-calendar-alt', identifier: 'kriteria'
      }
    ]
  end

  def perencanaan_kota_items # rubocop:disable Metrics/MethodLength
    [
      {
        title: 'Tujuan Kota', href: tujuan_kota_path,
        icon: 'fas fa-landmark', identifier: 'tujuan_kota'
      },
      {
        title: 'Isu Strategis', href: isu_strategis_kota_path,
        icon: 'fas fa-tasks', identifier: 'isu_strategis_kota'
      },
      {
        title: 'Strategi Kota', href: strategi_kota_path,
        icon: 'far fa-clipboard', identifier: 'strategi_kota'
      },
      {
        title: 'Sasaran Kota', href: sasaran_kota_path,
        icon: 'fas fa-bullseye', identifier: 'sasaran_kota'
      },
      {
        title: 'Tematik Kota', href: tematiks_path,
        icon: 'fas fa-folder-plus', identifier: 'tematik_kota'
      },
      {
        title: 'Sub-Tematik Kota', href: sub_tematiks_tematiks_path,
        icon: 'fas fa-folder-plus', identifier: 'tematik_kota'
      },
      {
        title: 'Pohon Kinerja Kota', href: kota_pohon_kinerja_index_path,
        icon: 'fas fa-tree', identifier: 'pohon_kinerja/kota'
      }
    ]
  end

  def spbe_items
    [
      {
        title: 'Domain SPBE', href: domains_path, identifier: 'domain'
      },
      {
        title: 'Sub-domain SPBE', href: subdomains_path, identifier: 'domain'
      },
      {
        title: 'Kebutuhan SPBE', href: kebutuhans_path, identifier: 'kebutuhan'
      }
    ]
  end
end
