# == Schema Information
#
# Table name: programs
#
#  id                 :bigint           not null, primary key
#  id_program         :string
#  id_unik            :string
#  indikator          :string
#  kode_program       :string
#  nama_bidang_urusan :string
#  nama_program       :string
#  nama_urusan        :string
#  satuan             :string
#  tahun              :string
#  target             :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
class Program < ApplicationRecord
  scope :tahun, -> { where(tahun: Date.today.year) }
  scope :urusan, -> { group_by(&:nama_urusan) }
  scope :bidang, -> { group_by(&:nama_bidang_urusan) }
end
