# == Schema Information
#
# Table name: risikos
#
#  id                :bigint           not null, primary key
#  konteks_strategis :string
#  prioritas         :string
#  tahun_penilaian   :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  pohon_id          :bigint           not null
#  tujuan_kota_id    :bigint           not null
#
# Indexes
#
#  index_risikos_on_pohon_id        (pohon_id)
#  index_risikos_on_tujuan_kota_id  (tujuan_kota_id)
#
# Foreign Keys
#
#  fk_rails_...  (pohon_id => pohons.id)
#  fk_rails_...  (tujuan_kota_id => tujuan_kota.id)
#
require 'rails_helper'

RSpec.describe Risiko, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
