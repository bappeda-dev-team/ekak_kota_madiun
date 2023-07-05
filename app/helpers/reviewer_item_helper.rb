module ReviewerItemHelper
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
                   '\blaporans\/rankir1|\blaporans\/rankir2|\blaporans\/penetapan)')
  end
end
