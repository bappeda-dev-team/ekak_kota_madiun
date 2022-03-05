# == Schema Information
#
# Table name: strategi_keluarans
#
#  id         :bigint           not null, primary key
#  metode     :text
#  tahapan    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe StrategiKeluaran, type: :model do
  context 'validation' do
    it { should validate_presence_of(:metode) }
  end
end
