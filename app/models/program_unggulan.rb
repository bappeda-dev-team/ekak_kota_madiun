# == Schema Information
#
# Table name: program_unggulans
#
#  id          :bigint           not null, primary key
#  asta_karya  :string
#  keterangan  :string
#  tahun_akhir :string
#  tahun_awal  :string
#  urutan      :integer          default(1)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  lembaga_id  :bigint           not null
#
# Indexes
#
#  index_program_unggulans_on_lembaga_id  (lembaga_id)
#
# Foreign Keys
#
#  fk_rails_...  (lembaga_id => lembagas.id)
#
# ASTA KARYA WALKOT
class ProgramUnggulan < ApplicationRecord
  default_scope { order(:urutan) }
  belongs_to :lembaga

  validates :asta_karya, presence: { message: 'Asta Karya wajib diisi' },
                         length: { minimum: 4 },
                         uniqueness: { scope: %i[tahun_awal tahun_akhir],
                                       message: "Asta Karya ini sudah ada di periode terpilih" }

  validates :urutan, numericality: { only_integer: true }
  validates :tahun_awal, presence: { message: 'Tahun awal wajib diisi' },
                         length: { is: 4, message: 'Tahun tidak valid' }
  validates :tahun_akhir, presence: { message: 'Tahun akhir wajib diisi' },
                          length: { is: 4, message: 'Tahun tidak valid' }

  def to_s
    asta_karya
  end

  def periode
    "#{tahun_awal}-#{tahun_akhir}"
  end
end
