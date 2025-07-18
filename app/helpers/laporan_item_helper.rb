module LaporanItemHelper
  def laporan_items
    items = [
      {
        title: 'Usulan', href: "#",
        multi: true, collections: laporan_usulans,
        id_target: 'laporan-usulans',
        icon: 'fas fa-book', identifier: 'usulans'
      },
      {
        title: 'Indikator Opd', href: "#",
        multi: true, collections: laporan_indikators,
        id_target: 'indikator-opd',
        icon: 'fas fa-book', identifier: 'usulans'
      },
      {
        title: 'Rencana Aksi OPD', href: '#',
        multi: true, collections: rekap_rencana_aksis_opd,
        id_target: 'rekap-renaksi-opd',
        icon: 'fas fa-stream', identifier: 'laporans/rekapitulasi_rencana_aksi_opd/'
      },
      {
        title: 'Perintah Walikota', href: '#',
        multi: true, collections: rekap_perintah_walikota,
        id_target: 'rekap-perintah-walikota-opd',
        icon: 'fas fa-stream', identifier: 'laporans/rekapitulasi_perintah_walikota/'
      },
      {
        title: 'SPIP', href: spip_index_path,
        icon: 'fas fa-chalkboard', identifier: 'spip'
      },
      {
        title: 'Manajemen Risiko', href: daftar_resiko_laporans_path,
        icon: 'fas fa-chart-line', identifier: 'laporans/daftar_resiko'
      },
      {
        title: 'Rekap Standar Pelayanan', href: rekap_standar_pelayanan_laporans_path,
        icon: 'fas fa-book-open', identifier: 'laporans/rekap_standar_pelayanan'
      },
      {
        title: 'SPBE', href: '#',
        multi: true, collections: rekap_laporan_spbe,
        id_target: 'rekap-laporan-spbe',
        icon: 'fas fa-tablet-alt', identifier: 'laporans/spbe/'
      },
      { title: 'Gender', href: laporan_gap_genders_path,
        icon: 'fas fa-people-carry',
        identifier: 'laporans/laporan_gap' },
      {
        title: 'Rancangan Peraturan', href: "#",
        multi: true, collections: peraturan_items,
        id_target: 'peraturan-items',
        icon: 'fas fa-book-reader', identifier: 'peraturan'
      },
      {
        title: 'Inovasi Sasaran Kinerja', href: inovasi_sasaran_kinerja_laporans_path,
        icon: 'fas fa-book-open', identifier: 'laporans/inovasi_sasaran_kinerja'
      },
      {
        title: 'Sasaran Penduduk', href: sasaran_penduduk_laporans_path,
        icon: 'fas fa-book-open', identifier: 'laporans/sasaran_penduduk'
      },
      {
        title: 'Cascading Kota', href: hasil_cascading_kota_laporans_path,
        icon: 'fas fa-people-arrows', identifier: 'laporans/hasil_cascading_kota'
      },
      {
        title: 'Cascading Opd', href: hasil_cascading_laporans_path,
        icon: 'fas fa-people-arrows', identifier: 'laporans/hasil_cascading'
      },
      {
        title: 'Crosscutting Opd', href: hasil_crosscutting_laporans_path,
        icon: 'fas fa-puzzle-piece', identifier: 'laporans/hasil_crosscutting'
      },
      {
        title: 'Rekap Pokin Operational', href: rekap_pokin_operational_laporans_path,
        icon: 'fas fa-puzzle-piece', identifier: 'laporans/rekap_pokin_operational'
      },
      {
        title: 'Tim Kerja', href: tim_kerja_laporans_path,
        icon: 'fas fa-user-friends', identifier: 'laporans/tim_kerja'
      },
      {
        title: 'Rencana Kinerja (KAK)', href: laporan_kak_laporans_path,
        icon: 'fas fa-bullseye', identifier: 'laporans/laporan_kak'
      },
      {
        title: 'Rincian Belanja', href: laporan_rka_laporans_path,
        icon: 'fas fa-money-check', identifier: 'laporans/laporan_rka'
      },
      {
        title: 'Sasaran Program OPD', href: sasaran_program_opd_laporans_path,
        icon: 'fas fa-folder-open', identifier: 'laporans/sasaran_program_opd'
      },
      {
        title: 'Renstra', href: "#",
        multi: true, collections: renstra_items,
        id_target: 'renstra-items',
        icon: 'fas fa-stream', identifier: 'renstra'
      },
      {
        title: 'Renja', href: "#",
        multi: true, collections: renja_items,
        id_target: 'renja-items',
        icon: 'fas fa-tasks', identifier: 'renja'
      }
    ]
    return items unless super_admin? && !guest?

    items.push({
                 title: 'Rekap Pagu', href: "#",
                 multi: true, collections: rekap_pagu_items,
                 id_target: 'rekap-pagu-items',
                 icon: 'fas fa-tasks', identifier: 'rekap_pagu'
               })
  end

  def rekap_pagu_items
    [
      { title: 'Pagu Ranwal', href: rekaps_pagu_ranwal_path, identifier: 'rekaps_pagu_ranwal' },
      { title: 'Pagu Rancangan', href: rekaps_pagu_rancangan_path, identifier: 'rekaps_pagu_rancangan' },
      { title: 'Pagu Rankir', href: rekaps_pagu_rankir_path, identifier: 'rekaps_pagu_rankir' },
      { title: 'Pagu Penetapan', href: rekaps_pagu_penetapan_path, identifier: 'rekaps_pagu_penetapan' },
      { title: 'Perbandingan Pagu', href: rekaps_perbandingan_pagu_path, identifier: 'rekaps_perbandingan_pagu' }
    ]
  end

  def laporan_indikators
    [
      { title: 'RPJP', href: rpjp_opd_indikators_path, identifier: 'rpjp_opd' },
      { title: 'RB', href: indikator_rb_laporans_path, identifier: 'laporan_indikator_rb' },
      { title: 'LPPD', href: indikator_lppd_laporans_path, identifier: 'laporan_indikator_lppd' },
      { title: 'SPM', href: indikator_spm_laporans_path, identifier: 'laporan_indikator_spm' },
      { title: 'SDGs', href: indikator_sdgs_laporans_path, identifier: 'laporan_indikator_sdgs' }
    ]
  end

  def peraturan_items
    [
      { title: 'Perda', href: output_raperda_laporans_path,
        icon: 'fas fa-book-open',
        identifier: 'laporan-output-raperda' },
      { title: 'Perwal', href: output_perwal_laporans_path,
        icon: 'fas fa-book-open',
        identifier: 'laporan-output-raperda' },
      { title: 'SK Walikota', href: output_sk_walikota_laporans_path,
        icon: 'fas fa-book-open',
        identifier: 'laporan-output-raperda' }
    ]
  end

  def rekap_items
    [
      {
        title: 'Rekap Rencana Kinerja', href: rekap_sasaran_sasarans_path,
        icon: 'fas fa-archive', identifier: 'rekap_sasaran'
      },
      {
        title: 'Rekap Strategi', href: rekap_strategi_strategis_path,
        icon: 'fas fa-archive', identifier: 'rekap_strategi'
      }
    ]
  end

  def manrisk_items
    [
      {
        title: 'Konteks Strategis', href: konteks_strategis_manrisks_path,
        icon: 'fas fa-stream', identifier: 'konteks_strategis_manrisk'
      },
      {
        title: 'Identifikasi Strategis', href: identifikasi_strategis_manrisks_path,
        icon: 'fas fa-file-alt', identifier: 'identifikasi_strategis_manrisk'
      }
    ]
  end

  def rekap_rencana_aksis_opd
    [
      {
        title: 'Data', href: data_rekapitulasi_rencana_aksi_opd_laporans_path,
        icon: 'fas fa-stream', identifier: 'laporans/rekapitulasi_rencana_aksi_opd/data'
      },
      {
        title: 'Jumlah', href: jumlah_rekapitulasi_rencana_aksi_opd_laporans_path,
        icon: 'fas fa-file-alt', identifier: 'laporans/rekapitulasi_rencana_aksi_opd/jumlah'
      }
    ]
  end

  def rekap_perintah_walikota
    [
      {
        title: 'Data', href: data_rekapitulasi_perintah_walikota_laporans_path,
        icon: 'fas fa-stream', identifier: 'laporans/rekapitulasi_perintah_walikota/data'
      },
      {
        title: 'Jumlah', href: jumlah_rekapitulasi_perintah_walikota_laporans_path,
        icon: 'fas fa-file-alt', identifier: 'laporans/rekapitulasi_perintah_walikota/jumlah'
      }
    ]
  end

  def rekap_laporan_spbe
    [
      {
        title: 'SPBE', href: spbe_laporans_path,
        icon: 'fas fa-tablet-alt', identifier: 'laporans/spbe'
      },
      {
        title: 'BPMN SPBE', href: rekap_bpmn_spbe_laporans_path,
        icon: 'fas fa-tablet-alt', identifier: 'laporans/rekap_bpmn_spbe'
      }
    ]
  end
end
