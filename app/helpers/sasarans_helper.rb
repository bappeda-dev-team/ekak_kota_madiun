module SasaransHelper
  def diajukan?
    @sasaran.status == 'pengajuan' || @sasaran.status == 'disetujui'
  end
end
