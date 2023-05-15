module SidebarItemHelper
  def sidebar_items
    if current_user.has_role?(:super_admin)
      render partial: 'layouts/sidebar_super_admin'
    elsif current_user.has_role?(:admin)
      render partial: 'layouts/sidebar_admin'
    elsif current_user.has_role?(:asn)
      render partial: 'layouts/sidebar_asn'
    else
      render partial: 'layouts/nonaktif'
    end
  end

  def perencanaan_items
    [
      { title: 'Usulan', href: usulans_path,
        icon: 'fas fa-book', identifier: 'usulans' },
      { title: 'Pohon Kinerja', href: asn_pohon_kinerja_index_path,
        icon: 'fas fa-tree', identifier: 'pohon_kinerja/asn' },
      { title: 'Rencana Kinerja', href: sasarans_path,
        icon: 'fas fa-bullseye', identifier: 'rencana_kinerja' },
      { title: 'Rincian Belanja', href: rincian_belanja_index_path,
        icon: 'fas fa-money-check', identifier: 'rincian_belanja' },
      { title: 'Manajemen Resiko', href: daftar_resiko_sasaran_program_opds_path,
        icon: 'fas fa-chart-line', identifier: 'sasaran_program_opds/daftar_resiko' },
      { title: 'Gender', href: gap_genders_path,
        icon: 'fas fa-people-carry', identifier: 'gap' }
    ]
  end

  def collapsed_perencanaan_items
    collapse_class('(' \
                   '\busulans|\bpohon_kinerja/asn|' \
                   '\brencana_kinerja|\brincian_belanja|' \
                   '\bsasaran_program_opds/daftar_resiko|' \
                   '\bgap|\brenja|\brenstra)')
  end

  def laporan_items
    [
      { title: 'Usulan', href: asn_pohon_kinerja_index_path, icon: 'fas fa-tree',
        identifier: 'pohon_kinerja/asn' },
      { title: 'Pohon Kinerja', href: asn_pohon_kinerja_index_path,
        icon: 'fas fa-file', identifier: 'pohon_kinerja/asn' },
      { title: 'Rencana Kinerja', href: rincian_belanja_index_path, icon: 'fas fa-money-check',
        identifier: 'rincian_belanja' },
      { title: 'Rincian Belanja', href: renstra_index_path, identifier: 'renstra', icon: 'fas fa-receipt' },
      { title: 'Manajemen Resiko', href: renstra_index_path, identifier: 'renstra', icon: 'fas fa-receipt' },
      { title: 'Gender', href: renstra_index_path, identifier: 'renstra', icon: 'fas fa-receipt' },
      { title: 'Renja', href: "#",
        icon: 'fas fa-tasks', identifier: 'renja',
        multi: true, collections: renja_items },
      { title: 'Renstra', href: renstra_index_path,
        icon: 'fas fa-stream', identifier: 'renstra' },
    ]
  end

  def collapsed_laporan_items
    collapse_class('(' \
                   '\busulans|\bpohon_kinerja/asn|' \
                   '\brencana_kinerja|\brincian_belanja|' \
                   '\bsasaran_program_opds/daftar_resiko|' \
                   '\bgap|\bgbs)')
  end

  def renja_items
    [
      { title: 'Ranwal', href: renja_ranwal_path, identifier: 'renja/ranwal' },
      { title: 'Rankir', href: renja_rankir_path, identifier: 'renja/rankir' },
      { title: 'Penetapan', href: renja_penetapan_path, identifier: 'renja/penetapan' }
    ]
  end


  def usulan_users
    [
      { title: 'Musrenbang', href: usulan_musrenbang_path, identifier: 'usulan_musrenbang' },
      { title: 'Pokok Pikiran', href: usulan_pokpir_path, identifier: 'usulan_pokpir' },
      { title: 'Mandatori', href: usulan_mandatori_path, identifier: 'usulan_mandatori' },
      { title: 'Inisiatif Walikota', href: usulan_inisiatif_path, identifier: 'usulan_inisiatif' }
    ]
  end

  def laporan_usulans
    [
      { title: 'Laporan Musrenbang', href: '/laporan_usulan/musrenbang', identifier: 'laporan_usulan\/musrenbang' },
      { title: 'Laporan Pokok Pikiran', href: '/laporan_usulan/pokpir', identifier: 'laporan_usulan\/pokpir' },
      { title: 'Laporan Mandatori', href: '/laporan_usulan/mandatori', identifier: 'laporan_usulan\/mandatori' },
      { title: 'Laporan Inisiatif Walikota', href: '/laporan_usulan/inisiatif',
        identifier: 'laporan_usulan\/inisiatif' }
    ]
  end

  def gender_items
    [
      { title: 'GAP', href: gap_genders_path, identifier: 'gap' },
      { title: 'GBS', href: gbs_genders_path, identifier: 'gbs' }
    ]
  end

  def usulan_items
    [
      { title: 'Musrenbang', href: musrenbangs_path, identifier: 'musrenbang' },
      { title: 'Pokok Pikiran', href: pokpirs_path, identifier: 'pokpir' },
      { title: 'Mandatori', href: mandatoris_path, identifier: 'mandatori' },
      { title: 'Inisiatif Walikota', href: inovasis_path, identifier: 'inovasi' }
    ]
  end

  def super_admin_items
    [
      { title: 'Role', href: roles_path, icon: 'fas fa-user-tag', identifier: 'roles' },
      { title: 'Master User', href: list_all_users_path, icon: 'fas fa-users', identifier: 'list_all' },
      { title: 'Tematik', href: subkegiatan_tematiks_path, identifier: 'tematik', icon: 'fas fa-tags' },
      { title: 'Kelompok Anggaran', href: kelompok_anggarans_path, icon: 'fas fa-folder',
        identifier: 'kelompok_anggaran' },
      { title: 'Skala Dampak Resiko', href: skalas_path, icon: 'fas fa-weight', identifier: 'skala' },
      { title: 'Admin Sasaran', href: adminsasarans_path, icon: 'fas fa-archive', identifier: 'adminsasarans' },
      { title: 'User Khusus', href: khusus_users_path, icon: 'fas fa-user-astronaut', identifier: 'khusus' }
    ]
  end

  def master_sipd_items
    [
      { title: 'Master Urusan', href: master_urusan_path, icon: 'fas fa-user-tag', identifier: 'master_urusan' },
      { title: 'Master Bidang Urusan', href: master_bidang_urusan_path, icon: 'fas fa-user-tag',
        identifier: 'master_bidang_urusan' },
      { title: 'Master Program', href: master_programs_path, icon: 'fas fa-user-tag', identifier: 'master_programs' },
      { title: 'Master Kegiatan', href: master_kegiatans_path, icon: 'fas fa-user-tag',
        identifier: 'master_kegiatans' },
      { title: 'Master Output', href: master_output_path, icon: 'fas fa-user-tag', identifier: 'master_output' },
      { title: 'Master Sub Kegiatan', href: master_subkegiatans_path, icon: 'fas fa-user-tag',
        identifier: 'master_subkegiatans' }
    ]
  end

  def collapsed_item_sipd_master
    collapse_class('(\bmaster_urusan|\bmaster_bidang_urusan|\bmaster_programs|\bmaster_kegiatans|\bmaster_output|\bmaster_subkegiatans)')
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

  def collapse_class(identifier)
    if request.path.match(/\b#{identifier}/)
      { aria: 'true', sub_menu: 'show',
        menu: '' }
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
