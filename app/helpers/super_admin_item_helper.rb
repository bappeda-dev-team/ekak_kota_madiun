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
        title: 'Master Jenis Jabatan', href: jenis_jabatans_path,
        icon: 'fas fa-user-check', identifier: 'jenis_jabatans'
      },
      {
        title: 'Daftar Pengguna Aplikasi', href: all_users_path,
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
        icon: 'fas fa-building', identifier: 'master_bidang'
      },
      {
        title: 'Master Program Kegiatan Subkegiatan OPD', href: admin_sub_kegiatan_path,
        icon: 'fas fa-folder-open', identifier: 'master_program_kegiatan_subkegiatan_opd'
      },
      {
        title: 'Master Rencana Kinerja', href: sasaran_admin_sasarans_path,
        icon: 'fas fa-archive', identifier: 'adminsasarans'
      },
      {
        title: 'Master Indikator', href: indikators_path,
        icon: 'fas fa-ruler', identifier: 'indikators'
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
        title: 'Skala', href: skalas_path,
        icon: 'fas fa-table', identifier: 'skala'
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
        icon: 'fas fa-external-link-alt', identifier: 'external_url'
      },
      {
        title: 'Status Tombol', href: status_tombols_path,
        icon: 'fas fa-check-square', identifier: 'status_tombol'
      }
    ]
  end

  def perencanaan_kota_items # rubocop:disable Metrics/MethodLength
    [
      {
        title: 'Visi Kota', href: visis_path,
        icon: 'fas fa-landmark', identifier: 'visi_kota'
      },
      {
        title: 'Misi Kota', href: misis_path,
        icon: 'fas fa-landmark', identifier: 'misi_kota'
      },
      {
        title: 'Tujuan Kota', href: tujuan_kota_path,
        icon: 'fas fa-landmark', identifier: 'tujuan_kota'
      },
      {
        title: 'Sasaran Kota / RAD', href: sasaran_kota_path,
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
        title: 'RPJP', href: '#',
        multi: true, collections: indikator_rpjp_items,
        id_target: 'rpjp-indikator',
        identifier: 'rpjp'
      },
      {
        title: 'RPJMD', href: '#',
        multi: true, collections: indikator_rpjmd_items,
        id_target: 'rpjmd-indikator',
        identifier: 'rpjmd'
      },
      {
        title: 'RKPD', href: '#',
        multi: true, collections: indikator_rkpd_items,
        id_target: 'rkpd-indikator',
        identifier: 'rkpd'
      },
      {
        title: 'IKU', href: iku_kota_indikators_path, identifier: 'iku_kota'
      },
      {
        title: 'RB', href: '#',
        multi: true, collections: indikator_rb_items,
        id_target: 'rb-indikator',
        identifier: 'rb'
      },
      {
        title: 'LPPD', href: '#',
        multi: true, collections: indikator_lppd_items,
        id_target: 'lppd-indikator',
        identifier: 'lppd'
      },
      {
        title: 'SPM', href: '#',
        multi: true, collections: indikator_spm_items,
        id_target: 'spm-indikator',
        identifier: 'spm'
      },
      {
        title: 'SDGs', href: '#',
        multi: true, collections: indikator_sdgs_items,
        id_target: 'sdgs-indikator',
        identifier: 'sdgs'
      },
      {
        title: 'Penanganan Stunting', href: '#',
        multi: true, collections: indikator_stunting_items,
        id_target: 'stunting-indikator',
        identifier: 'stunting-indikator'
      },
      {
        title: 'Penanganan TB', href: '#',
        multi: true, collections: indikator_tb_items,
        id_target: 'tb-penanganan-indikator',
        identifier: 'tb-penanganan-indikator'
      }
    ]
  end

  def indikator_rpjp_items
    [
      {
        title: 'Makro', href: rpjp_makro_indikators_path, identifier: 'rpjp_makro'
      }
    ]
  end

  def indikator_rpjmd_items
    [
      {
        title: 'Makro', href: rpjmd_makro_indikators_path, identifier: 'rpjmd_makro'
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

  def indikator_rb_items
    [
      {
        title: 'Indikator Outcome', href: rb_outcome_indikators_path, identifier: 'rb_outcome'
      },
      {
        title: 'Indikator Output', href: rb_output_indikators_path, identifier: 'rb_output'
      }
    ]
  end

  def indikator_lppd_items
    [
      {
        title: 'Indikator Outcome', href: lppd_outcome_indikators_path, identifier: 'lppd_outcome'
      },
      {
        title: 'Indikator Output', href: lppd_output_indikators_path, identifier: 'lppd_output'
      }
    ]
  end

  def indikator_spm_items
    [
      {
        title: 'Indikator Outcome', href: spm_outcome_indikators_path, identifier: 'spm_outcome'
      },
      {
        title: 'Indikator Output', href: spm_output_indikators_path, identifier: 'spm_output'
      }
    ]
  end

  def indikator_sdgs_items
    [
      {
        title: 'Indikator Outcome', href: sdgs_outcome_indikators_path, identifier: 'sdgs_outcome'
      },
      {
        title: 'Indikator Output', href: sdgs_output_indikators_path, identifier: 'sdgs_output'
      }
    ]
  end

  def indikator_stunting_items
    [
      {
        title: 'Indikator Outcome', href: stunting_outcome_indikators_path, identifier: 'stunting_outcome'
      },
      {
        title: 'Indikator Output', href: stunting_output_indikators_path, identifier: 'stunting_output'
      }
    ]
  end

  def indikator_tb_items
    [
      {
        title: 'Indikator Outcome', href: penanganan_tb_outcome_indikators_path, identifier: 'tb_penanganan_outcome'
      },
      {
        title: 'Indikator Output', href: penanganan_tb_output_indikators_path, identifier: 'tb_penanganan_output'
      }
    ]
  end
end
