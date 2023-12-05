require 'rails_helper'

RSpec.describe "IndikatorTambahans", type: :system do
  let(:admin) { create(:super_admin) }

  before(:each) do
    login_as admin
    visit root_path

    create_cookie('opd', 'test_opd')
    create_cookie('tahun', '2025')
  end

  context 'indikator rkpd' do
    it 'should show tematik kota, sub_tematik and their indikator' do
      visit rkpd_indikators_path

      expect(page).to have_text('Tematik A')
    end
  end
end
