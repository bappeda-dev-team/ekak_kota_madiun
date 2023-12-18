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
        title: 'Master Jabatan', href: jabatans_path,
        icon: 'fas fa-people', identifier: 'jabatans'
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
      },
      {
        title: 'External API', href: external_urls_path,
        icon: 'fas fa-link-alt', identifier: 'external_url'
      },
      {
        title: 'Status Tombol', href: status_tombols_path,
        icon: 'fas fa-link-alt', identifier: 'status_tombol'
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
      },
      {
        title: 'Indikator', href: "#",
        multi: true, collections: indikator_items,
        id_target: "list-indikator",
        icon: 'fas fa-book-open', identifier: 'indikators'
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

  def indikator_items
    [
      {
        title: 'RKPD', href: '#',
        multi: true, collections: indikator_rkpd_items,
        id_target: 'rkpd-indikator',
        identifier: 'rkpd'
      },
      {
        title: 'IKU', href: iku_kota_indikators_path, identifier: 'iku_kota'
      }
    ]
  end

  def indikator_rkpd_items
    [
      {
        title: 'Makro', href: rkpd_makro_indikators_path, identifier: 'rkpd_makro'
      },
      {
        title: 'Tujuan', href: rkpd_tujuan_indikators_path, identifier: 'rkpd_tujuan'
      },
      {
        title: 'Sasaran', href: rkpd_sasaran_indikators_path, identifier: 'rkpd_sasaran'
      },
      {
        title: 'Program', href: rkpd_program_indikators_path, identifier: 'rkpd_program'
      }
    ]
  end
end
