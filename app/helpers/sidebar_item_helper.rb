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
      { title: 'Rincian Belanja', href: rincian_belanja_path,
        icon: 'fas fa-money-check', identifier: 'rincian_belanja' },
      { title: 'Manajemen Resiko', href: daftar_resiko_sasaran_program_opds_path,
        icon: 'fas fa-chart-line', identifier: 'sasaran_program_opds/daftar_resiko' },
      { title: 'GAP', href: gap_genders_path,
        icon: 'fas fa-people-carry', identifier: 'gap' },
      { title: 'GBS', href: gbs_genders_path,
        icon: 'fas fa-people-carry', identifier: 'gbs' }
    ]
  end

  def collapsed_perencanaan_items
    collapse_class('(' \
                   '\busulans|\bpohon_kinerja/asn|' \
                   '\brencana_kinerja|\brincian_belanja|' \
                   '\bsasaran_program_opds/daftar_resiko|' \
                   '\bgap|\bgbs)')
  end

  def laporan_items
    [
      { title: 'Usulan', href: asn_pohon_kinerja_index_path, icon: 'fas fa-tree',
        identifier: 'pohon_kinerja/asn' },
      { title: 'Pohon Kinerja', href: asn_pohon_kinerja_index_path,
        icon: 'fas fa-file', identifier: 'pohon_kinerja/asn' },
      { title: 'Rencana Kinerja', href: rincian_belanja_path, icon: 'fas fa-money-check',
        identifier: 'rincian_belanja' },
      { title: 'Rincian Belanja', href: renstra_index_path, identifier: 'renstra', icon: 'fas fa-receipt' },
      { title: 'Manajemen Resiko', href: renstra_index_path, identifier: 'renstra', icon: 'fas fa-receipt' },
      { title: 'Gender', href: renstra_index_path, identifier: 'renstra', icon: 'fas fa-receipt' }
    ]
  end

  def collapsed_laporan_items
    collapse_class('(' \
                   '\busulans|\bpohon_kinerja/asn|' \
                   '\brencana_kinerja|\brincian_belanja|' \
                   '\bsasaran_program_opds/daftar_resiko|' \
                   '\bgap|\bgbs)')
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
