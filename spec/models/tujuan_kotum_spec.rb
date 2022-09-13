# == Schema Information
#
# Table name: tujuan_kota
#
#  id          :bigint           not null, primary key
#  id_misi     :string
#  id_tujuan   :string
#  misi        :string
#  tahun_akhir :string
#  tahun_awal  :string
#  tujuan      :string
#  visi        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require 'rails_helper'

RSpec.describe TujuanKotum, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
