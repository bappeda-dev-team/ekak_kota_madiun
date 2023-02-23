# == Schema Information
#
# Table name: strategis
#
#  id              :bigint           not null, primary key
#  nip_asn         :string
#  role            :string
#  strategi        :string
#  tahun           :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  opd_id          :string
#  pohon_id        :bigint
#  sasaran_id      :string
#  strategi_ref_id :string
#
# Indexes
#
#  index_strategis_on_pohon_id  (pohon_id)
#
require 'rails_helper'

RSpec.describe Strategi, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
