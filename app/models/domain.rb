# == Schema Information
#
# Table name: domains
#
#  id          :bigint           not null, primary key
#  domain      :string
#  keterangan  :string
#  kode_domain :string
#  tahun       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Domain < ApplicationRecord
end
