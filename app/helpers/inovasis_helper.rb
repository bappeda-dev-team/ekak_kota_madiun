module InovasisHelper
  def statuses(code: nil)
    codes = { nil: 'Menunggu diambil', draft: 'Menunggu diambil',
              pengajuan: 'Aktifkan', disetujui: 'Disetujui', aktif: 'Aktif',
              ditolak: 'ditolak', menunggu_persetujuan: 'Setujui?' }
    codes[code&.to_sym]
  end

  def jenis_inovasi
    %w[Baru Pengembangan Replikasi Sanggahan]
  end

  def option_tag_inovasi
    Inovasi::TAG_INOVASI
  end
end
