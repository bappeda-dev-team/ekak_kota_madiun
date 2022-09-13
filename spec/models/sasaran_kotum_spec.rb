# == Schema Information
#
# Table name: sasaran_kota
#
#  id           :bigint           not null, primary key
#  id_misi      :string
#  id_sasaran   :string
#  id_tujuan    :string
#  kode_sasaran :string
#  misi         :string
#  sasaran      :string
#  tahun_akhir  :string
#  tahun_awal   :string
#  tujuan       :string
#  visi         :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_sasaran_kota_on_id_sasaran  (id_sasaran) UNIQUE
#
require 'rails_helper'

RSpec.describe SasaranKotum, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
