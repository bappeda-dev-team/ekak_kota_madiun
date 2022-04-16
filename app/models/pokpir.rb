# == Schema Information
#
# Table name: pokpirs
#
#  id         :bigint           not null, primary key
#  alamat     :string
#  is_active  :boolean          default(FALSE)
#  nip_asn    :string
#  opd        :string
#  status     :enum             default("draft")
#  tahun      :string
#  usulan     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  sasaran_id :bigint
#
# Indexes
#
#  index_pokpirs_on_sasaran_id  (sasaran_id)
#  index_pokpirs_on_status      (status)
#
class Pokpir < ApplicationRecord
  validates :usulan, presence: true

  enum status: { draft: 'draft', pengajuan: 'pengajuan', disetujui: 'disetujui', ditolak: 'ditolak' }

  belongs_to :sasaran, optional: true
  has_many :usulans, as: :usulanable

  default_scope { order(created_at: :desc) }

  def self.type
    "Pokok Pikiran DPRD"
  end
end
