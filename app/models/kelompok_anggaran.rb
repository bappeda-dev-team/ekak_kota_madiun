# == Schema Information
#
# Table name: kelompok_anggarans
#
#  id            :bigint           not null, primary key
#  kelompok      :string
#  kode_kelompok :string
#  tahun         :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class KelompokAnggaran < ApplicationRecord
  validates :kelompok, inclusion: { in: %w[Awal Perubahan], message: 'gunakan (Awal atau Perubahan)' }
  validates :kode_kelompok, inclusion: { in: %w[_awal _perubahan],
                                         message: 'kode tidak sesuai, gunakan ( _awal atau_perubahan)' },
                            uniqueness: { scope: :tahun,
                                          message: 'kode kelompok sudah ada di tahun yang sama' }
  validates :tahun, numericality: { only_integer: true, greater_than_or_equal_to: 2020, less_than_or_equal_to: 2050 }

  before_validation :kode_kelompok_maker

  def jenis_kelompok
    {
      awal: { kelompok: 'Awal', kode: '_awal' },
      perubahan: { kelompok: 'Perubahan', kode: '_perubahan' }
    }
  end

  def kode_kelompok_maker
    self.kode_kelompok = "_#{kelompok.downcase}"
  end
end
