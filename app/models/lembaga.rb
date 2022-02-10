# == Schema Information
#
# Table name: lembagas
#
#  id           :bigint           not null, primary key
#  nama_lembaga :string
#  tahun        :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class Lembaga < ApplicationRecord
  has_many :opds
end
