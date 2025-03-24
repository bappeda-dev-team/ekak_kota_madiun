# == Schema Information
#
# Table name: rencana_aksi_opds
#
#  id                 :bigint           not null, primary key
#  id_rencana_renaksi :string           not null
#  is_hidden          :boolean          default(FALSE)
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
  has_one :rencana_renaksi, class_name: 'Sasaran', primary_key: :id_rencana_renaksi, foreign_key: :id_rencana
  belongs_to :sasaran

  def aksi
    rencana_renaksi.to_s
  end
end
