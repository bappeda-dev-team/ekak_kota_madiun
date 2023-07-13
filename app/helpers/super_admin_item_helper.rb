module SuperAdminItemHelper
  def super_admin_items # rubocop:disable Metrics/MethodLength
    [
      {
        title: 'Master Usulan', href: "#",
        multi: true, collections: usulan_items,
        id_target: "master-usulan",
        collapse_items: collapsed_item_usulan,
        icon: 'fas fa-book-open', identifier: 'usulans'
      },
      {
        title: 'Master Anggaran', href: "#",
        multi: true, collections: anggaran_items,
        id_target: "master-anggaran",
        collapse_items: collapsed_item_anggaran,
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
        collapse_items: collapsed_item_spbe,
        icon: 'fas fa-tablet-alt', identifier: 'spbes'
      }
    ]
  end

  def collapsed_super_admin_items
    collapse_class('(' \
                   '\bmusrenbangs|\bpokpirs|' \
                   '\bmandatoris|\binovasis|' \
                   '\banggaran_sshes|\banggaran_sbus|' \
                   '\banggaran_hspks|\brekenings|' \
                   '\blist_all|\btematiks|' \
                   '\bperiodes|\btahuns|' \
                   '\bkelompok_anggarans|' \
                   '\bdomains|' \
                   '\bsubdomains|' \
                   '\bkebutuhans|' \
                   '\badminsasarans|\busers\/khusus)')
  end

  def perencanaan_kota_items # rubocop:disable Metrics/MethodLength
    [
      {
        title: 'Tujuan', href: tujuan_kota_path,
        icon: 'fas fa-city', identifier: 'tujuan_kota'
      },
      {
        title: 'Isu Strategis', href: isu_strategis_kota_path,
        icon: 'fas fa-tree', identifier: 'isu_strategis_kota'
      },
      {
        title: 'Strategi', href: strategi_kota_path,
        icon: 'fas fa-bullseye', identifier: 'strategi_kota'
      },
      {
        title: 'Sasaran', href: sasaran_kota_path,
        icon: 'fas fa-bullseye', identifier: 'sasaran_kota'
      },
      {
        title: 'Pohon Kinerja', href: kota_pohon_kinerja_index_path,
        icon: 'fas fa-bullseye', identifier: 'pohon_kinerja/kota'
      }
    ]
  end

  def collapsed_perencanaan_kota_items
    collapse_class('(' \
                   '\btujuan_kota|\bisu_strategis_kota|' \
                   '\bstrategi_kota|\bsasaran_kota|' \
                   '\bpohon_kinerja\/kota)')
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

  def collapsed_item_spbe
    collapse_class('(\bdomains|\bsubdomains|\bkebutuhans)')
  end
end
