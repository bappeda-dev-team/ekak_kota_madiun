module SubItemHelper
  def usulan_items
    [
      { title: 'Musrenbang', href: musrenbangs_path, identifier: 'musrenbang' },
      { title: 'Pokok Pikiran', href: pokpirs_path, identifier: 'pokpir' },
      { title: 'Mandatori', href: mandatoris_path, identifier: 'mandatori' },
      { title: 'Mandatori SPBE', href: spbe_mandatoris_path, identifier: 'spbe_mandatori' },
      { title: 'Inisiatif Walikota', href: inovasis_path, identifier: 'inovasis' },
      { title: 'Inovasi Masyarakat', href: inovasi_masyarakats_path, identifier: 'masyarakat_inovasi' }
    ]
  end

  def anggaran_items
    [
      { title: 'SSH', href: anggaran_sshes_path, identifier: 'anggaran_ssh' },
      { title: 'SBU', href: anggaran_sbus_index_path, identifier: 'anggaran_sbu' },
      { title: 'SBK', href: anggaran_sbks_path, identifier: 'anggaran_sbk' },
      { title: 'HSPK', href: anggaran_hspks_path, identifier: 'anggaran_hspks' },
      { title: 'ASB', href: anggaran_asbs_path, identifier: 'anggaran_asb' },
      { title: 'Kode Rekening', href: rekenings_path, identifier: 'rekening' }
    ]
  end

  def collapsed_item_anggaran
    collapse_class('(\banggaran_ssh|\banggaran_sbu|\banggaran_hspk|\brekening)')
  end

  def renja_items
    [
      { title: 'Ranwal', href: renja_ranwal_path, identifier: 'renja_ranwal' },
      { title: 'Rancangan', href: renja_rancangan_path, identifier: 'renja_rancangan' },
      { title: 'Rankir', href: renja_rankir_path, identifier: 'renja_rankir' }
    ]
  end

  def renstra_items
    [
      { title: '(2019-2024)', href: renstra_index_path(periode: '2019-2024'), identifier: 'renstra/(2019-2024)' },
      { title: '(2025-2026)', href: renstra_index_path(periode: '2025-2026'), identifier: 'renstra/(2025-2026)' }
    ]
  end
end
