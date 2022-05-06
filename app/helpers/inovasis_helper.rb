module InovasisHelper
  def statuses(code: nil)
    codes = { nil: 'Menunggu diambil', draft: 'Menunggu diambil',
              pengajuan: 'Aktifkan', disetujui: 'Disetujui', aktif: 'Aktif',
              ditolak: 'ditolak', menunggu_persetujuan: 'Setujui?' }
    codes[code&.to_sym]
  end
end
