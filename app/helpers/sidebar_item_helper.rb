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
        icon: 'fas fa-book', identifier: 'usulans'
      },
      {
        title: 'SPIP', href: spip_index_path,
        icon: 'fas fa-chalkboard', identifier: 'spip'
      },
      {
        title: 'Pohon Kinerja Kota', href: rekap_pohon_kinerja_index_path,
        icon: 'fas fa-bullseye', identifier: 'pohon_kinerja/rekap'
      },
      {
        title: 'Pohon Kinerja OPD', href: rekap_opd_pohon_kinerja_index_path,
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
        icon: 'fas fa-tasks', identifier: 'renja'
      },
      {
        title: 'Rekap Rencana Kinerja', href: rekap_sasaran_sasarans_path,
        icon: 'fas fa-archive', identifier: 'rekap_sasaran'
      }
    ]
  end

  def status_icon(status)
    if status
      content_tag(:i, '', class: 'fas fa-check text-success')
    else
      content_tag(:i, '', class: 'fas fa-times text-danger')
    end
  end
end
