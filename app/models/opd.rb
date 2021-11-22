# == Schema Information
# Table name: opds
# id        :integer
# nama_opd  :string
# kode_opd  :string
class Opd < ApplicationRecord
  validates :nama_opd, presence: true
  validates :kode_opd, presence: true
  has_many :users
end
