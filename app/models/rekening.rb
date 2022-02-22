# == Schema Information
#
# Table name: rekenings
#
#  id             :bigint           not null, primary key
#  jenis_rekening :string
#  kode_rekening  :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class Rekening < ApplicationRecord
end
