# == Schema Information
#
# Table name: opd_bidangs
#
#  id               :bigint           not null, primary key
#  id_daerah        :string
#  kode_unik_bidang :string
#  kode_unik_opd    :string
#  nama_bidang      :string
#  nip_kepala       :string
#  pangkat_kepala   :string
#  tahun            :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  lembaga_id       :bigint
#  opd_id           :bigint
#
class OpdBidang < ApplicationRecord
  validates :nama_bidang, presence: true
  validates :opd_id, presence: true

  belongs_to :opd
  belongs_to :lembaga
end
