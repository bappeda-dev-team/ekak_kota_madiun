# == Schema Information
#
# Table name: rincians
#
#  id                  :bigint           not null, primary key
#  sasaran_id          :bigint           not null
#  data_terpilah       :string
#  penyebab_internal   :string
#  penyebab_external   :string
#  permasalahan_umum   :string
#  permasalahan_gender :string
#  resiko              :string
#  lokasi_pelaksanaan  :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
require 'rails_helper'

RSpec.describe Rincian, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
