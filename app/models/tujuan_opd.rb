# == Schema Information
#
# Table name: tujuans
#
#  id            :bigint           not null, primary key
#  id_tujuan     :string           not null
#  kode_unik_opd :string
#  tujuan        :string
#  type          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_tujuans_on_id_tujuan  (id_tujuan) UNIQUE
#
class TujuanOpd < Tujuan
  has_many :indikators, lambda {
                          where(jenis: 'Tujuan', sub_jenis: 'Opd')
                        }, class_name: 'Indikator', foreign_key: 'kode', primary_key: 'id_tujuan'

  def indikator_tujuans
    tujuan = indikators.group_by(&:indikator).transform_values do |indikator|
      indikator.group_by(&:tahun)
    end
    {
      indikator_tujuan: tujuan.to_h
    }
  end
end
