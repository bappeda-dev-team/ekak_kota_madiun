# frozen_string_literal: true

class TotalAnggaran
  attr_accessor :kode_unik_opd, :tahun

  def initialize(kode_unik_opd, tahun)
    @kode_unik_opd = kode_unik_opd
    @tahun = tahun
  end

  def opd
    Opd.find_by(kode_unik_opd: @kode_unik_opd)
  end

  def sasarans
    opd.users.eselon4.map { |user| user.sasarans.where(tahun: @tahun) }.flatten
  end

  def subkegiatans
    sasarans.group_by do |sas|
      { nama_subkegiatan: sas.subkegiatan, kode_subkegiatan: sas.kode_subkegiatan }
    end
  end

  def anggarans
    subkegiatans.transform_values do |ss|
      ss.map(&:total_anggaran).compact.inject(:+)
    end
  end

  def sync_pagu_kak
    save_to_pagu(anggarans)
  end

  private

  def save_to_pagu(anggarans)
    anggarans.each do |sub, pagu|
      data_pagu = {
        jenis: 'Perencanaan',
        sub_jenis: 'SubKegiatan',
        tahun: @tahun,
        kode_opd: @kode_unik_opd,
        kode: sub[:kode_subkegiatan],
        anggaran: pagu,
        keterangan: 'Pagu Perencanaan SubKegiatan OPD',
        created_at: Time.now, updated_at: Time.now
      }
      PaguAnggaran.insert(data_pagu)
    end
  end
end
