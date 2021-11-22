# == Schema Information
# Table name: lembagas
# id            :integer
# nama_lembaga  :string
# tahun         :time
class Lembaga < ApplicationRecord
  has_many :opds
end
