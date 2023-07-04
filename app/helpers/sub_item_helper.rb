module SubItemHelper
  def usulan_items
    [
      { title: 'Musrenbang', href: musrenbangs_path, identifier: 'musrenbang' },
      { title: 'Pokok Pikiran', href: pokpirs_path, identifier: 'pokpir' },
      { title: 'Mandatori', href: mandatoris_path, identifier: 'mandatori' },
      { title: 'Mandatori SPBE', href: spbe_mandatoris_path, identifier: 'spbe_mandatori' },
      { title: 'Inisiatif Walikota', href: inovasis_path, identifier: 'inovasi' }
    ]
  end

  def collapsed_item_usulan
    collapse_class('(\binovasis|\basn_musrenbangs|\bmusrenbangs|\bpokpirs|\bmandatoris)')
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
end
