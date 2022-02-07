# == Schema Information
#
# Table name: tahapans
#
#  id               :bigint           not null, primary key
#  bulan            :string
#  jumlah_realisasi :integer
#  jumlah_target    :integer
#  keterangan       :string
#  progress         :integer
#  realisasi        :integer
#  tahapan_kerja    :string
#  target           :integer
#  waktu            :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  rincian_id       :bigint           not null
#
# Indexes
#
#  index_tahapans_on_rincian_id  (rincian_id)
#
# Foreign Keys
#
#  fk_rails_...  (rincian_id => rincians.id)
#
require 'rails_helper'

RSpec.describe Tahapan, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
