# == Schema Information
#
# Table name: opds
#
#  id                 :bigint           not null, primary key
#  bidang_urusan      :string
#  id_opd_skp         :integer
#  kode_bidang_urusan :string
#  kode_opd           :string
#  kode_unik_opd      :string
#  kode_urusan        :string
#  nama_opd           :string
#  urusan             :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  lembaga_id         :integer
#
# Indexes
#
#  index_opds_on_kode_opd  (kode_opd) UNIQUE
#
class Opd < ApplicationRecord
  validates :nama_opd, presence: true
  validates :kode_opd, presence: true
  has_many :users
  has_many :program_kegiatans
  belongs_to :lembaga
end
