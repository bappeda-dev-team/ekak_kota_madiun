# == Schema Information
#
# Table name: sumber_danas
#
#  id               :bigint           not null, primary key
#  kode_sumber_dana :string
#  sumber_dana      :string
#  tahun            :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
require 'rails_helper'

RSpec.describe SumberDana, type: :model do
  context 'crud' do
    it 'can create sumber dana' do
      sumber_dana = SumberDana.create(
        kode_sumber_dana: '1',
        sumber_dana: 'DAU',
        tahun: '2022'
      )
      expect(sumber_dana).to be_valid
    end
  end
end
