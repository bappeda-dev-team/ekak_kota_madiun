module SidebarItemHelper # rubocop:disable Metrics/ModuleLength
  def sidebar_items
    if current_user.has_role?(:super_admin)
      render partial: 'layouts/sidebar_super_admin'
    elsif current_user.has_role?(:admin)
      render partial: 'layouts/sidebar_admin'
    elsif current_user.has_role?(:reviewer)
      render partial: 'layouts/sidebar_reviewer'
    elsif current_user.has_role?(:asn)
      render partial: 'layouts/sidebar_asn'
    else
      render partial: 'layouts/nonaktif'
    end
  end

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
        title: 'Kelompok Anggaran', href: kelompok_anggarans_path,
        icon: 'fas fa-folder', identifier: 'kelompok_anggaran'
      },
      {
        title: 'SPBE', href: spbes_path,
        icon: 'fas fa-tablet-alt', identifier: 'spbe'
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
                   '\bkelompok_anggarans|' \
                   '\bspbes|' \
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
      },
      {
        title: 'Rekap Pohon Kinerja', href: rekap_pohon_kinerja_index_path,
        icon: 'fas fa-bullseye', identifier: 'pohon_kinerja/rekap'
      }
    ]
  end

  def collapsed_perencanaan_kota_items
    collapse_class('(' \
                   '\btujuan_kota|\bisu_strategis_kota|' \
                   '\bstrategi_kota|\bsasaran_kota|' \
                   '\bpohon_kinerja\/kota|' \
                   '\bpohon_kinerja\/rekap|)')
  end

  def perencanaan_opd_items
    [
      {
        title: 'Tujuan OPD', href: tujuan_opds_path,
        icon: 'fas fa-city', identifier: 'tujuan_opds'
      },
      {
        title: 'Isu Strategis OPD', href: isu_strategis_opds_path,
        icon: 'fas fa-bullseye', identifier: 'isu_strategis_opds'
      },
      {
        title: 'Pohon Kinerja OPD', href: opd_pohon_kinerja_index_path,
        icon: 'fas fa-tree', identifier: 'pohon_kinerja/opd'
      },
      # { title: 'Sasaran OPD', href: sasaran_opds_path, identifier: 'opds/sasaran' },
      # { title: 'Kotak Usulan OPD', href: kotak_usulan_opds_path,
      #   identifier: 'opds/kotak_usulan' },
      {
        title: 'Info OPD', href: info_opds_path,
        icon: 'fas fa-building', identifier: 'opds/info'
      },
      {
        title: 'SPBE', href: index_opd_spbes_path,
        icon: 'fas fa-tablet-alt', identifier: 'spbe_opd'
      }
    ]
  end

  def collapsed_perencanaan_opd_items
    collapse_class('(' \
                   '\btujuan_opds|\bisu_strategis_opds|' \
                   '\bstrategi_opds|\bsasaran_opds|' \
                   '\bpohon_kinerja/opd|' \
                   '\bspbes\/index_opd|' \
                   '\bpohon_kinerja/rekap_opd|\bopds/info)')
  end

  def perencanaan_items # rubocop:disable Metrics/MethodLength
    [
      {
        title: 'Usulan', href: "#",
        multi: true, collections: usulan_users,
        id_target: 'perencanaan-usulan',
        collapse_items: collapsed_item_usulan_user,
        icon: 'fas fa-book', identifier: 'usulans'
      },
      {
        title: 'Pohon Kinerja', href: asn_pohon_kinerja_index_path,
        icon: 'fas fa-tree', identifier: 'pohon_kinerja/asn'
      },
      {
        title: 'Rencana Kinerja', href: sasarans_path,
        icon: 'fas fa-bullseye', identifier: 'rencana_kinerja'
      },
      {
        title: 'Rincian Belanja', href: rincian_belanja_index_path,
        icon: 'fas fa-money-check', identifier: 'rincian_belanja'
      },
      {
        title: 'Manajemen Resiko', href: daftar_resiko_sasaran_program_opds_path,
        icon: 'fas fa-chart-line', identifier: 'sasaran_program_opds/daftar_resiko'
      },
      {
        title: 'Gender', href: gap_genders_path,
        icon: 'fas fa-people-carry', identifier: 'gap'
      },
      {
        title: 'SPBE', href: index_opd_spbes_path,
        icon: 'fas fa-tablet-alt', identifier: 'spbe_opd'
      }
    ]
  end

  def collapsed_perencanaan_items
    collapse_class('(' \
                   '\busulan_inisiatif|\busulan_musrenbang|' \
                   '\busulan_pokpir|\busulan_mandatori|' \
                   '\bpohon_kinerja/asn|' \
                   '\brencana_kinerja|\brincian_belanja|' \
                   '\bsasaran_program_opds/daftar_resiko|)')
  end

  def laporan_items # rubocop:disable Metrics/MethodLength
    [
      {
        title: 'Usulan', href: "#",
        multi: true, collections: laporan_usulans,
        id_target: 'laporan-usulans',
        collapse_items: collapsed_laporan_usulan_items,
        icon: 'fas fa-book', identifier: 'usulans'
      },
      {
        title: 'Rekap Pohon Kinerja', href: rekap_opd_pohon_kinerja_index_path,
        icon: 'fas fa-tree', identifier: 'pohon_kinerja/rekap'
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
        title: 'Renstra', href: renstra_index_path,
        icon: 'fas fa-stream', identifier: 'renstra'
      },
      {
        title: 'Renja', href: "#",
        multi: true, collections: renja_items,
        id_target: 'renja-items',
        collapse_items: collapsed_renja_items,
        icon: 'fas fa-tasks', identifier: 'renja'
      }
    ]
  end

  def collapsed_laporan_items
    collapse_class('(' \
                   '\blaporans\/laporan_usulan|\blaporans\/laporan_pohon|' \
                   '\blaporans\/laporan_kak|\blaporans\/laporan_rka|' \
                   '\brenstra|\brenja\/ranwal|' \
                   '\brenja\/rankir|\brenja\/penetapan|)')
  end

  def renja_items
    [
      { title: 'Ranwal', href: renja_ranwal_path, identifier: 'renja/ranwal' },
      { title: 'Rankir - 1', href: renja_rankir_1_path, identifier: 'renja/rankir' },
      { title: 'Rankir - 2', href: renja_rankir_path, identifier: 'renja/rankir' },
      { title: 'Penetapan', href: renja_penetapan_path, identifier: 'renja/penetapan' }
    ]
  end

  def collapsed_renja_items
    collapse_class('(\brenja/ranwal|\brenja/rankir|\brenja/penetapan)')
  end

  def tematik_items
    [
      { title: 'SPBE', href: spbe_laporans_path, identifier: 'laporans/spbe' }
    ]
  end

  def collapsed_tematik_items
    collapse_class('(\blaporans/spbe)')
  end

  def usulan_users
    [
      { title: 'Musrenbang', href: usulan_musrenbang_path, identifier: 'usulan_musrenbang' },
      { title: 'Pokok Pikiran', href: usulan_pokpir_path, identifier: 'usulan_pokpir' },
      { title: 'Mandatori', href: usulan_mandatori_path, identifier: 'usulan_mandatori' },
      { title: 'Inisiatif Walikota', href: usulan_inisiatif_path, identifier: 'usulan_inisiatif' }
    ]
  end

  def collapsed_item_usulan_user
    collapse_class('(\busulan_inisiatif|\busulan_musrenbang|\busulan_pokpir|\busulan_mandatori)')
  end

  def laporan_usulans
    [
      { title: 'Musrenbang', href: '/laporan_usulan/musrenbang', identifier: 'laporan_usulan\/musrenbang' },
      { title: 'Pokok Pikiran', href: '/laporan_usulan/pokpir', identifier: 'laporan_usulan\/pokpir' },
      { title: 'Mandatori', href: '/laporan_usulan/mandatori', identifier: 'laporan_usulan\/mandatori' },
      { title: 'Inisiatif Walikota', href: '/laporan_usulan/inisiatif',
        identifier: 'laporan_usulan\/inisiatif' }
    ]
  end

  def collapsed_laporan_usulan_items
    collapse_class('(\blaporan_usulan)')
  end

  def usulan_items
    [
      { title: 'Musrenbang', href: musrenbangs_path, identifier: 'musrenbang' },
      { title: 'Pokok Pikiran', href: pokpirs_path, identifier: 'pokpir' },
      { title: 'Mandatori', href: mandatoris_path, identifier: 'mandatori' },
      { title: 'Inisiatif Walikota', href: inovasis_path, identifier: 'inovasi' }
    ]
  end

  def anggaran_items
    [
      { title: 'SSH', href: anggaran_sshes_path, identifier: 'anggaran_ssh' },
      { title: 'SBU', href: anggaran_sbus_index_path, identifier: 'anggaran_sbu' },
      { title: 'HSPK', href: anggaran_hspks_path, identifier: 'anggaran_hspks' },
      { title: 'Kode Rekening', href: rekenings_path, identifier: 'rekening' }
    ]
  end

  def collapsed_item_anggaran
    collapse_class('(\banggaran_ssh|\banggaran_sbu|\banggaran_hspk|\brekening)')
  end

  def collapsed_item_usulan
    collapse_class('(\binovasis|\basn_musrenbangs|\bmusrenbangs|\bpokpirs|\bmandatoris)')
  end

  def reviewer_items
    [
      {
        title: 'Pohon Kinerja Kota', href: review_kota_pohon_kinerja_index_path,
        icon: 'fas fa-solar-panel', identifier: 'pohon_kinerja/review_kota'
      },
      {
        title: 'Pohon Kinerja OPD', href: review_opd_pohon_kinerja_index_path,
        icon: 'fas fa-tree', identifier: 'pohon_kinerja/review_opd'
      }
    ]
  end

  def laporan_reviewer_items
    [
      {
        title: 'Rencana Kinerja (KAK)', href: laporan_kak_laporans_path,
        icon: 'fas fa-bullseye', identifier: 'laporan_kak'
      },
      {
        title: 'Rincian Belanja', href: laporan_rka_laporans_path,
        icon: 'fas fa-money-check', identifier: 'laporan_rka'
      },
      {
        title: 'Renstra', href: renstra_laporans_path,
        icon: 'fas fa-stream', identifier: 'renstra'
      },
      {
        title: 'Renja', href: "#",
        multi: true, collections: laporan_renja_items,
        id_target: 'renja-items',
        collapse_items: collapsed_laporan_renja_items,
        icon: 'fas fa-tasks', identifier: 'renja'
      }
    ]
  end

  def collapsed_reviewer_items
    collapse_class('(\bpohon_kinerja\/review_opd|\bpohon_kinerja\/review_kota)')
  end

  def collapsed_laporan_reviewer_items
    collapse_class('(' \
                   '\blaporans\/laporan_usulan|' \
                   '\blaporans\/laporan_kak|\blaporans\/laporan_rka|' \
                   '\blaporans\/renstra|\blaporans\/ranwal|' \
                   '\blaporans\/rankir1|\blaporans\/rankir2|\blaporans\/penetapan|)')
  end

  def laporan_renja_items
    [
      { title: 'Ranwal', href: ranwal_laporans_path, identifier: 'laporans/ranwal' },
      { title: 'Rankir - 1', href: rankir1_laporans_path, identifier: 'laporans/rankir' },
      { title: 'Rankir - 2', href: rankir2_laporans_path, identifier: 'laporans/rankir' },
      { title: 'Penetapan', href: penetapan_laporans_path, identifier: 'laporans/penetapan' }
    ]
  end

  def collapsed_laporan_renja_items
    collapse_class('(\blaporans\/ranwal|\blaporans\/rankir1|\blaporans\/rankir2|\blaporans\/penetapan)')
  end

  def collapse_class(identifier)
    if request.path.match(/\b#{identifier}/)
      { aria: 'true', sub_menu: 'show', menu: '' }
    else
      { aria: 'false', sub_menu: 'collapse', menu: 'collapsed' }
    end
  end

  def status_icon(status)
    if status
      content_tag(:i, '', class: 'fas fa-check text-success')
    else
      content_tag(:i, '', class: 'fas fa-times text-danger')
    end
  end
end
