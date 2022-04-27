# == Schema Information
#
# Table name: sumber_danas
#
#  id               :bigint           not null, primary key
#  kode_sumber_dana :string
#  sumber_dana      :string
#  tahun            :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
class SumberDana < ApplicationRecord
end
