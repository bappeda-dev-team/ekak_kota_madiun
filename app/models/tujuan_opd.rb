# == Schema Information
#
# Table name: tujuans
#
#  id               :bigint           not null, primary key
#  id_tujuan        :string           not null
#  kode_unik_opd    :string
#  tahun_akhir      :string
#  tahun_awal       :string
#  tujuan           :string
#  type             :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  bidang_urusan_id :bigint
#  urusan_id        :bigint
#
class TujuanOpd < Tujuan
  has_many :indikators, lambda {
                          where(jenis: 'Tujuan', sub_jenis: 'Opd')
                        }, class_name: 'Indikator', foreign_key: 'kode', primary_key: 'id_tujuan'
  has_many :targets, through: :indikators

  accepts_nested_attributes_for :indikators, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :targets, reject_if: :all_blank, allow_destroy: true

  belongs_to :urusan, class_name: 'Master::Urusan', foreign_key: 'urusan_id'
  belongs_to :bidang_urusan, class_name: 'Master::BidangUrusan', foreign_key: 'bidang_urusan_id'

  scope :by_periode, lambda { |tahun|
                       where("tahun_awal::integer <= ?::integer", tahun)
                         .where("tahun_akhir::integer >= ?::integer", tahun)
                     }

  def to_s
    tujuan
  end

  def indikator_tujuans
    tujuan = indikators.group_by(&:indikator).transform_values do |indikator|
      indikator.group_by(&:tahun)
    end
    {
      indikator_tujuan: tujuan.to_h
    }
  end

  def indikators_tujuan
    indikators.uniq(&:indikator)
  end

  def urusan_opd
    "#{urusan&.kode_urusan} - #{urusan&.nama_urusan}"
  end

  def bidang_urusan_opd
    bidang_urusan&.kode_nama_bidang
  end

  def periode_tujuan
    "#{tahun_awal}-#{tahun_akhir}"
  end
end
