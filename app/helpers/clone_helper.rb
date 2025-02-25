module CloneHelper
  def kelompok_anggaran_options(tahun)
    KelompokAnggaran.where.not(tahun: tahun)
                    .collect { |ka| [ka.nama_sederhana_kelompok_tahun, ka.id] }
  end
end
