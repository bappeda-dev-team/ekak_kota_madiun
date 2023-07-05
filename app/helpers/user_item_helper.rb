module UserItemHelper
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
end
