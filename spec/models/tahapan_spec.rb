# == Schema Information
#
# Table name: tahapans
#
#  id               :bigint           not null, primary key
#  rincian_id       :bigint           not null
#  tahapan_kerja    :string
#  target           :integer
#  realisasi        :integer
#  bulan            :string
#  jumlah_target    :integer
#  jumlah_realisasi :integer
#  keterangan       :string
#  waktu            :integer
#  progress         :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
require 'rails_helper'

RSpec.describe Tahapan, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
