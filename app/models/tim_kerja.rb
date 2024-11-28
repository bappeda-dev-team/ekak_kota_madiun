# Get Tim kerja data from Pohon Kinerja Cascading
class TimKerja
  def initialize(kode_opd: '', tahun: '')
    @kode_opd = kode_opd
    @tahun = tahun
  end

  def opd
    @opd ||= Opd.find_by(kode_unik_opd: @kode_opd)
  end

  def strategic_opd
    @strategic_opd ||= opd.strategis.includes(%i[strategi_bawahans pohon_shareds])
                          .where(type: 'StrategiPohon', role: 'eselon_2', tahun: @tahun)
                          .select { |sp| sp.pohon_shareds.any? }
  end

  def tactical_opd
    @tactical_opd ||= opd.strategis.includes(%i[strategi_bawahans pohon_shareds])
                         .where(type: 'StrategiPohon', role: 'eselon_3', tahun: @tahun)
                         .select { |sp| sp.pohon_shareds.any? }
  end

  def tim_kerja_strategi
    tim_kerja = tactical_opd.flat_map do |strategi|
      tim_kerja_hash(strategi)
    end
    tim_kerja.select { |tim| tim[:susunan_tim].any? }
  end

  def tim_kerja_hash(strategi)
    {
      id_tim: strategi.id,
      nama_tim: strategi.strategi,
      penanggung_jawab: penanggung_jawab(strategi),
      dasar_hukum: dasar_hukum_tim(strategi),
      susunan_tim: susunan_tim(strategi),
      rincian_tugas: rincian_tugas(strategi)
    }
  end

  def dasar_hukum_tim(strategi)
    strategi_bawahans(strategi).flat_map do |pohon|
      sasaran_pelaksana(pohon).flat_map do |sas|
        sas.dasar_hukums.filter_map do |das_hu|
          dasar_hukum = if das_hu.judul_dasar_hukum_tim_kerja.present?
                          [das_hu.id, das_hu.judul_dasar_hukum_tim_kerja]
                        else
                          [das_hu.id, das_hu.judul]
                        end
          dasar_hukum if das_hu.status_dasar_hukum_tim_kerja != false
        end
      end
    end.uniq
  end

  def susunan_tim(strategi)
    all_pelaksana = atasan_pelaksana(strategi) + pelaksana_strategi(strategi) + pelaksana_bawahan(strategi)
    all_pelaksana.group_by { |pl| { id: pl[:role_id], role: pl[:role] } }.sort_by { |key, _| key[:id] }
  end

  def rincian_tugas(strategi)
    strategi_bawahans(strategi).flat_map do |pohon|
      sasaran_pelaksana(pohon).filter_map do |sas|
        sasarans = if sas.judul_rincian_tugas.present?
                     [sas.id, sas.judul_rincian_tugas]
                   else
                     [sas.id, sas.sasaran_kinerja]
                   end
        sasarans if sas.status_rincian_tugas != false
      end
    end.uniq
  end

  def penanggung_jawab(strategi)
    strategi.strategi_atasan.pohon_shareds.flat_map { |pl| pl.user.nama_nip_kurung }.last
  end

  private

  def strategi_bawahans(strategi)
    strategi.strategi_bawahans.flat_map do |sp_bawahan|
      pelaksana(sp_bawahan)
    end
  end

  def pohon_bawahans(strategi)
    strategi.strategi_bawahans.flat_map do |sp_bawahan|
      pelaksana(sp_bawahan)
    end
  end

  def atasan_pelaksana(strategi)
    pelaksana(strategi.strategi_atasan).flat_map do |pelaksana|
      pelaksana_hash(pelaksana)
    end
  end

  def pelaksana_strategi(strategi)
    pelaksana(strategi).flat_map do |pelaksana|
      pelaksana_hash(pelaksana)
    end
  end

  def pelaksana_bawahan(strategi)
    pohon_bawahans(strategi).flat_map do |pelaksana|
      pelaksana_hash(pelaksana)
    end
  end

  def pelaksana_hash(pelaksana)
    {
      strategi_id: pelaksana.id,
      role_id: role_tim_id(pelaksana.role_tim),
      role: pelaksana.role_tim,
      pelaksana: pelaksana.user.nama_nip_kurung,
      sasaran_terisi: sasaran_pelaksana_terisi?(pelaksana),
      is_inovator: pelaksana.is_inovator
    }
  end

  def role_tim_id(role)
    case role
    when 'Penanggung Jawab'
      0
    when 'Koordinator'
      1
    when 'Ketua'
      2
    else
      3
    end
  end

  def pelaksana(strategi)
    strategi.pohon_shareds
            .includes(%i[user pohonable])
            .where.not(role: %w[opd opd-batal])
            .select { |pelaksana| pelaksana.role_tim.present? }
  end

  def sasaran_pelaksana(pohon)
    pohon.pohonable.sasarans
  end

  def sasaran_pelaksana_terisi?(pohon)
    sasaran_pelaksana(pohon).any? { |s| s.nip_asn == pohon.user.nik }
  end
end
