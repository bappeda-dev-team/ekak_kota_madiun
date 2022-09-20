require 'rails_helper'

RSpec.describe "CRUD Sasaran", type: :system do
  let(:user) { FactoryBot.create(:asn) }
  let(:sasaran) { FactoryBot.create(:sasaran) }

  before(:each) do
    user.sasarans.create!(sasaran_kinerja: 'Test Sasaran')
    visit root_path
    fill_in "user_login", with: user.email
    fill_in "password", with: user.password
    click_button "Sign in"
  end

  context 'first success login' do
    scenario 'asn with at least one sasaran but not shown' do
      expect(page).to have_content('Sasaran Kinerja / Rencana Kinerja')
      expect(page).to have_content('Jumlah sasaran: 1')
      expect(page).to_not have_content('Test Sasaran')
    end
  end

  context 'rencana kinerja asn' do
    scenario 'asn see their sasaran here' do
      visit user_sasarans_path(user)
      expect(page).to have_content('Test Sasaran')
    end
    it 'show their sasaran' do
      sasaran = user.sasarans.first
      visit user_sasarans_path(user)
      first(:css, 'i.fas.fa-book-open').click
      expect(page).to have_current_path(user_sasaran_path(user, sasaran))
    end
  end
end
