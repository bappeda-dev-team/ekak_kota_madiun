# == Schema Information
#
# Table name: periodes
#
#  id          :bigint           not null, primary key
#  tahun_akhir :string
#  tahun_awal  :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require 'rails_helper'

RSpec.describe Periode, type: :model do
  it 'should find periode by either tahun_awal or tahun_akhir' do
    periode = create(:periode, tahun_awal: '2025', tahun_akhir: '2026')
    find_periode = Periode.find_tahun('2025')

    expect(find_periode).to include periode
  end
end
