# == Schema Information
#
# Table name: asets
#
#  id            :bigint           not null, primary key
#  jumlah        :integer
#  keterangan    :string
#  kode_unik_opd :string
#  kondisi       :text             default([]), is an Array
#  nama_aset     :string
#  satuan        :string
#  tahun_akhir   :integer
#  tahun_awal    :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Aset < ApplicationRecord
  KONDISI_ASET = %w[Baik Cukup Kurang]

  belongs_to :opd, foreign_key: :kode_unik_opd, primary_key: :kode_unik_opd

  validates :nama_aset, presence: true
  validates :jumlah, presence: true, numericality: { greater_than_or_equal: 0 }
  validates :satuan, presence: true

  after_validation { nama_aset.upcase! }

  scope :all_tahun, lambda { |tahun|
                      where("tahun_awal <= ?::integer", tahun)
                        .where("tahun_akhir >= ?::integer", tahun)
                    }

  def to_s
    nama_aset
  end

  def perolehan_aset
    awal = tahun_awal.to_i
    akhir = tahun_akhir.to_i
    range = (awal..akhir).to_a
    range.to_sentence(last_word_connector: ', ')
  end
end
