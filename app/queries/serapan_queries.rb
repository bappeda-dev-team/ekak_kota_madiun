class SerapanQueries
  def initialize(kode_opd: '', tahun: '', periode: '')
    @kode_opd = kode_opd
    @tahun = tahun
    @periode = periode
    @tahun_awal = periode.first
    @tahun_akhir = periode.last
  end

  def opd
    Opd.find_by(kode_unik_opd: @kode_opd)
  end

  def bidang_urusan_pagu
    bidang_urusans = opd.list_bidang_urusans
    bidang_urusans.map do |bu|
      { kode: bu[0],
        nama: bu[1],
        pagu: pagu_periode(bu[0]),
        realisasi: realisasi_periode(bu[0]) }
    end
  end

  def pagu_anggarans(kode)
    PaguAnggaran.where(jenis: 'PaguSerapan',
                       sub_jenis: 'BidangUrusan',
                       kode: kode,
                       kode_opd: @kode_opd,
                       tahun: @periode)
  end

  def pagu_periode(kode)
    pagu_anggarans(kode).to_h do |pa|
      [pa.tahun.to_i, pa.anggaran]
    end
  end

  def realisasi_periode(kode)
    pagu_anggarans(kode).to_h do |pa|
      [pa.tahun.to_i, pa.anggaran_realisasi]
    end
  end
end
