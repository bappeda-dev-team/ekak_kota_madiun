# == Schema Information
#
# Table name: periodes
#
#  id            :bigint           not null, primary key
#  jenis_periode :string           default("RPJMD")
#  tahun_akhir   :string
#  tahun_awal    :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class Periode < ApplicationRecord
  has_many :tahuns

  # validates_uniqueness_of :tahun_awal
  validates_uniqueness_of :tahun_akhir

  scope :find_tahun, lambda { |tahun|
                       where("tahun_awal::integer <= ?::integer", tahun)
                         .where("tahun_akhir::integer >= ?::integer", tahun)
                         .first
                     }
  scope :find_tahun_rpjmd, lambda { |tahun|
                             where("jenis_periode = 'RPJMD' AND tahun_awal::integer <= ? AND tahun_akhir::integer >= ?", tahun, tahun)
                           }
  scope :find_tahun_all, lambda { |tahun|
                           where("tahun_awal::integer <= ?::integer", tahun)
                             .where("tahun_akhir::integer >= ?::integer", tahun)
                         }

  def to_s
    "#{tahun_awal}-#{tahun_akhir}"
  end

  def tahun_in_periode
    awal = tahun_awal.to_i
    akhir = tahun_akhir.to_i
    (awal..akhir)
  end
end
