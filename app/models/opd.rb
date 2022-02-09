# == Schema Information
#
# Table name: opds
#
#  id         :bigint           not null, primary key
#  nama_opd   :string
#  kode_opd   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  lembaga_id :integer
#
class Opd < ApplicationRecord
  validates :nama_opd, presence: true
  validates :kode_opd, presence: true
  has_many :users
  has_many :program_kegiatans
  belongs_to :lembaga
end
