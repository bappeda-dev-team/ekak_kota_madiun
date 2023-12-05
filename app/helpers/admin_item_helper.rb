module AdminItemHelper
  def perencanaan_opd_items # rubocop:disable Metrics
    [
      {
        title: 'Permasalahan dan Isu Strategis', href: isu_dan_permasalahans_path,
        icon: 'fas fa-city', identifier: 'isu_permaslahaan'
      },
      {
        title: 'Strategi Arah Kebijakan', href: opd_strategi_arah_kebijakans_path,
        icon: 'fas fa-city', identifier: 'strategi_kebijakan'
      },
      {
        title: 'Anggaran', href: "#",
        multi: true, collections: anggaran_admin_items,
        id_target: "master-anggaran",
        icon: 'fas fa-coins', identifier: 'anggaran'
      },
      {
        title: 'Master Usulan', href: "#",
        multi: true, collections: usulan_items,
        id_target: "master-usulan",
        icon: 'fas fa-book-open', identifier: 'usulans'
      },
      {
        title: 'Tujuan OPD', href: tujuan_opds_path,
        icon: 'fas fa-city', identifier: 'tujuan_opds'
      },
      {
        title: 'Pohon Kinerja Kota', href: kota_pohon_kinerja_index_path,
        icon: 'fas fa-sitemap', identifier: 'pohon_kinerja/kota'
      },
      {
        title: 'Pohon Kinerja', href: pohon_kinerja_opds_path,
        icon: 'fas fa-tree', identifier: 'pohon_kinerja'
      },
      {
        title: 'Pohon Cascading', href: cascading_pohon_kinerja_opds_path,
        icon: 'fas fa-tree', identifier: 'pohon_kinerja'
      },
      {
        title: 'Info OPD', href: info_opds_path,
        icon: 'fas fa-building', identifier: 'opds/info'
      },
      {
        title: 'Indikator', href: "#",
        multi: true, collections: indikator_opd_items,
        id_target: "list-indikator-opd",
        icon: 'fas fa-book-open', identifier: 'indikators'
      },
      {
        title: 'Daftar ASN', href: adminusers_path,
        icon: 'fas fa-user', identifier: 'admin_user'
      },
      {
        title: 'Peta Rencana SPBE', href: index_opd_spbes_path,
        icon: 'fas fa-tablet-alt', identifier: 'spbe_opd'
      },
      {
        title: 'Manajemen Resiko', href: daftar_resiko_sasaran_program_opds_path,
        icon: 'fas fa-chart-line', identifier: 'sasaran_program_opds/daftar_resiko'
      },
      {
        title: 'Pagu Perencanaan', href: daftar_renstra_program_kegiatans_path,
        icon: 'fas fa-chart-line', identifier: 'daftar_renstra'
      },
      {
        title: 'Pagu SIPKD', href: daftar_pagu_program_kegiatans_path,
        icon: 'fas fa-chart-line', identifier: 'daftar_pagu'
      }
    ]
  end

  def anggaran_admin_items
    [
      { title: 'SSH', href: anggaran_sshes_path, identifier: 'anggaran_ssh' },
      { title: 'SBU', href: anggaran_sbus_index_path, identifier: 'anggaran_sbu' },
      { title: 'HSPK', href: anggaran_hspks_path, identifier: 'anggaran_hspks' }
    ]
  end

  def indikator_opd_items
    [
      {
        title: 'Renja', href: renja_opd_indikators_path,
        multi: true, collections: indikator_renja_items,
        id_target: 'renja-indikator',
        identifier: 'renja'
      },
      { title: 'IKU', href: iku_opd_indikators_path, identifier: 'iku_opd' },
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
        title: 'RB', href: '#',
        multi: true, collections: indikator_rb_items,
        id_target: 'rb-indikator',
        identifier: 'rb'
      }
    ]
  end

  def indikator_renja_items
    [
      {
        title: 'Sasaran', href: sasaran_renja_opd_indikators_path, identifier: 'sasaran_renja_opd'
      },
      {
        title: 'Program', href: program_renja_opd_indikators_path, identifier: 'sasaran_program_opd'
      },
      {
        title: 'Kegiatan', href: kegiatan_renja_opd_indikators_path, identifier: 'sasaran_kegiatan_opd'
      },
      {
        title: 'Subkegiatan', href: subkegiatan_renja_opd_indikators_path, identifier: 'sasaran_subkegiatan_opd'
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
end
