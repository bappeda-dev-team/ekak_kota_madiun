module AdminItemHelper
  def perencanaan_opd_items
    [
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
        title: 'Isu Strategis OPD', href: isu_strategis_opds_path,
        icon: 'fas fa-bullseye', identifier: 'isu_strategis_opds'
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
        title: 'Program/Kegiatan', href: pks_opd_program_kegiatans_path,
        icon: 'fas fa-building', identifier: 'opds/info'
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

  def perencanaan_opd_pu_items
    [
      {
        title: 'Anggaran HSPK', href: anggaran_hspks_path,
        icon: 'fas fa-city', identifier: 'anggaran_hspk'
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
        title: 'Isu Strategis OPD', href: isu_strategis_opds_path,
        icon: 'fas fa-bullseye', identifier: 'isu_strategis_opds'
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
        title: 'Program/Kegiatan', href: pks_opd_program_kegiatans_path,
        icon: 'fas fa-building', identifier: 'opds/info'
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
      }
    ]
  end
end
