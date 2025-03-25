# == Schema Information
#
# Table name: rencana_aksi_opds
#
#  id                 :bigint           not null, primary key
#  id_rencana_renaksi :string           not null
#  is_hidden          :boolean          default(FALSE)
#  keterangan         :string
#  kode_opd           :string
#  tahun              :string
#  tw1                :string
#  tw2                :string
#  tw3                :string
#  tw4                :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  sasaran_id         :bigint           not null
#
# Indexes
#
#  index_rencana_aksi_opds_on_sasaran_id  (sasaran_id)
#
# Foreign Keys
#
#  fk_rails_...  (sasaran_id => sasarans.id)
#
class RencanaAksiOpd < ApplicationRecord
  default_scope { order(:id) }
  has_one :rencana_renaksi, class_name: 'Sasaran', primary_key: :id_rencana_renaksi, foreign_key: :id_rencana
  belongs_to :sasaran

  def to_s
    rencana_renaksi.to_s
  end

  def aksi
    rencana_renaksi.to_s
  end

  def update_tw_pelaksanaan
    target_setahun = rencana_renaksi.total_target_aksi_bulan
    tw1 = target_setahun.values_at(1, 2, 3).compact_blank.sum
    tw2 = target_setahun.values_at(4, 5, 6).compact_blank.sum
    tw3 = target_setahun.values_at(7, 8, 9).compact_blank.sum
    tw4 = target_setahun.values_at(10, 11, 12).compact_blank.sum
    renaksi_opd = self
    renaksi_opd.update(
      tw1: tw1,
      tw2: tw2,
      tw3: tw3,
      tw4: tw4
    )
  end
end
