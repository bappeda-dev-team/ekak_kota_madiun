module SidebarItemHelper
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
                   '\bpohon_kinerja\/rekap_opd|' \
                   '\brenja\/rankir|\brenja\/penetapan)')
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
