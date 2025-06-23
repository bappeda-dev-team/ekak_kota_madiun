module AdminItemHelper
  def perencanaan_opd_items # rubocop:disable Metrics
    items = [
      {
        title: 'Sasaran Kota / RAD', href: laporan_sasaran_kota_path,
        icon: 'fas fa-bullseye', identifier: 'sasaran_kota_laporan'
      },
      {
        title: 'Strategi Arah Kebijakan', href: opd_strategi_arah_kebijakans_path,
        icon: 'fas fa-city', identifier: 'strategi_kebijakan'
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
        title: 'Sasaran OPD', href: sasaran_opds_path,
        icon: 'fas fa-tasks', identifier: 'sasaran_opds'
      },
      {
        title: 'Rencana Aksi OPD', href: rencana_aksi_opds_path,
        icon: 'fas fa-bullseye', identifier: 'rencana_aksi_opds'
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
        title: 'SPBE', href: "#",
        multi: true, collections: spbe_opd_items,
        id_target: "list-spbe-opd",
        icon: 'fas fa-tablet-alt', identifier: 'spbes'
      },
      {
        title: 'Pagu Perencanaan', href: daftar_renstra_program_kegiatans_path,
        icon: 'fas fa-chart-line', identifier: 'daftar_renstra'
      },
      {
        title: 'Pagu SIPKD', href: daftar_pagu_program_kegiatans_path,
        icon: 'fas fa-chart-line', identifier: 'daftar_pagu'
      },
      {
        title: 'Master Program Kegiatan Subkegiatan OPD', href: admin_sub_kegiatan_path,
        icon: 'fas fa-folder-open', identifier: 'master_program_kegiatan_subkegiatan_opd'
      }
    ]
    return items if guest?

    items.push(
      {
        title: 'Anggaran', href: "#",
        multi: true, collections: anggaran_admin_items,
        id_target: "master-anggaran",
        icon: 'fas fa-coins', identifier: 'anggaran'
      },
      {
        title: 'Daftar ASN', href: adminusers_path,
        icon: 'fas fa-user', identifier: 'admin_user'
      },
      {
        title: 'Rekap Rencana Kinerja', href: rekap_sasaran_sasarans_path,
        icon: 'fas fa-archive', identifier: 'rencana_kinerja/rekap_sasaran'
      }
    )
  end

  def anggaran_admin_items
    [
      { title: 'SSH', href: anggaran_sshes_path, identifier: 'anggaran_ssh' },
      { title: 'SBU', href: anggaran_sbus_index_path, identifier: 'anggaran_sbu' },
      { title: 'SBK', href: anggaran_sbks_path, identifier: 'anggaran_sbk' },
      { title: 'HSPK', href: anggaran_hspks_path, identifier: 'anggaran_hspks' },
      { title: 'ASB', href: anggaran_asbs_path, identifier: 'anggaran_asb' }
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
      { title: 'IKU', href: iku_opd_indikators_path, identifier: 'iku_opd' }
    ]
  end

  def indikator_renja_items
    [
      {
        title: 'Tujuan', href: tujuan_renja_opd_indikators_path, identifier: 'tujuan_renja_opd'
      },
      {
        title: 'Sasaran', href: sasaran_renja_opd_indikators_path, identifier: 'sasaran_renja_opd'
      },
      {
        title: 'Program', href: program_renja_opd_indikators_path, identifier: 'program_renja_opd'
      },
      {
        title: 'Kegiatan', href: kegiatan_renja_opd_indikators_path, identifier: 'kegiatan_renja_opd'
      },
      {
        title: 'Subkegiatan', href: subkegiatan_renja_opd_indikators_path, identifier: 'subkegiatan_renja_opd'
      }
    ]
  end

  def spbe_opd_items
    [
      {
        title: 'Peta Rencana SPBE', href: index_opd_spbes_path,
        icon: 'fas fa-tablet-alt', identifier: 'spbe_opd'
      },
      {
        title: 'BPMN SPBE', href: pilih_bpmn_spbes_path,
        icon: 'fas fa-tablet-alt', identifier: 'bpmn_spbes/pilih'
      }
    ]
  end
end
