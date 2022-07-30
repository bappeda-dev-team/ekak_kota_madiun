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
  validates :kelompok, presence: true,
                       inclusion: { in: %w[Awal Perubahan], message: '- gunakan (Awal atau Perubahan)' },
                       uniqueness: { scope: :tahun,
                                     message: 'kelompok sudah ada di tahun yang sama' }
  validates :kode_kelompok, uniqueness: { scope: :tahun,
                                          message: 'kode kelompok sudah ada di tahun yang sama' }
  validates :tahun, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 2020, message: 'tahun minimal 2020' }

  after_validation :kode_kelompok_maker

  def jenis_kelompok
    {
      awal: { kelompok: 'Awal', kode: '_awal' },
      perubahan: { kelompok: 'Perubahan', kode: '_perubahan' }
    }
  end

  def kode_kelompok_maker
    return false if tahun.nil? || kelompok.nil?

    self.kode_kelompok = "_#{tahun}_#{kelompok.downcase}"
  end
end
