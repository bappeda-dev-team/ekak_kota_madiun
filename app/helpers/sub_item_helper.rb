module SubItemHelper
  def program_unggulan_items
    [
      {
        title: 'Asta Karya', href: asta_karya_program_unggulans_path,
        identifier: 'asta_karya'
      },
      {
        title: 'Asta Cita', href: asta_cita_program_unggulans_path,
        identifier: 'asta_cita'
      },
      {
        title: 'Nawa Bhakti', href: nawa_bhakti_program_unggulans_path,
        identifier: 'nawa_bhakti'
      }
    ]
  end

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
      { title: 'Ranwal', href: renja_ranwal_path, identifier: 'renja/ranwal' },
      { title: 'Rancangan', href: renja_rancangan_path, identifier: 'renja/rancangan' },
      { title: 'Rankir', href: renja_rankir_path, identifier: 'renja/rankir' }
    ]
  end

  def renstra_items
    [
      { title: '(2019-2024)', href: renstra_index_path(periode: '2019-2024', jenis_periode: 'RPJMD'),
        identifier: 'renstra?jenis_periode=RPJMD&periode=2019-2024' },
      { title: '(2025-2026)', href: renstra_index_path(periode: '2025-2026', jenis_periode: 'RPD'),
        identifier: 'renstra?jenis_periode=RPD&periode=2025-2026' },
      { title: '(2025-2030)', href: renstra_index_path(periode: '2025-2030', jenis_periode: 'RPJMD'),
        identifier: 'renstra?jenis_periode=RPJMD&periode=2025-2030' }
    ]
  end
end
