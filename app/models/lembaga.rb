# == Schema Information
#
# Table name: lembagas
#
#  id           :bigint           not null, primary key
#  kode_lembaga :string
#  nama_lembaga :string
#  tahun        :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class Lembaga < ApplicationRecord
  has_many :opds
  has_many :isu_strategis_kota
  validates :nama_lembaga, presence: true

  def to_s
    nama_lembaga
  end

  def pohon_kinerja_kota(tahun)
    isu_strategis_kota.where(tahun: tahun).to_h do |isu_kota|
      [isu_kota, isu_kota.strategi_kotums.to_h do |str_kota|
        [str_kota, str_kota.pohons.to_h do |pohon|
          [pohon, pohon.strategi_kepala_by_opd]
        end]
      end]
    end
  end
end
