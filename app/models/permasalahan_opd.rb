# == Schema Information
#
# Table name: permasalahan_opds
#
#  id                         :bigint           not null, primary key
#  jenis                      :string
#  kode_opd                   :string
#  kode_permasalahan_external :string
#  permasalahan               :string
#  status                     :string
#  tahun                      :string
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  isu_strategis_opd_id       :bigint
#
# Indexes
#
#  index_permasalahan_opds_on_isu_strategis_opd_id  (isu_strategis_opd_id)
#
class PermasalahanOpd < ApplicationRecord
  belongs_to :isu_strategis_opd
  belongs_to :opd, foreign_key: :kode_opd, primary_key: :kode_unik_opd, optional: true

  def to_s
    permasalahan
  end
end
