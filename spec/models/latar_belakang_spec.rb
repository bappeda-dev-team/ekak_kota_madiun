# == Schema Information
#
# Table name: latar_belakangs
#
#  id                   :bigint           not null, primary key
#  dasar_hukum          :text
#  gambaran_umum        :text
#  id_indikator_sasaran :string
#  key_activities       :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  sasaran_id           :bigint
#
# Indexes
#
#  index_latar_belakangs_on_id_indikator_sasaran  (id_indikator_sasaran) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (sasaran_id => sasarans.id)
#
require 'rails_helper'

RSpec.describe LatarBelakang, type: :model do
  context 'validation' do
    it { should validate_presence_of(:gambaran_umum) }
    it { should belong_to(:sasaran).optional(true) }
  end
end
