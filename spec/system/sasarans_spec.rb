require 'rails_helper'

RSpec.describe "CRUD Sasaran", type: :system do
  let(:user) { FactoryBot.create(:asn) }
  let(:sasaran) { FactoryBot.create(:sasaran) }

  scenario 'asn dashboard page' do
    user
    visit root_path
    fill_in "user_login", with: user.email
    fill_in "password", with: user.password
    click_button "Sign in"
    expect(page).to have_content('Dashboard')
    expect(page).to have_content('Sasaran Kinerja / Rencana Kinerja')
    expect(page).to have_content('Jumlah sasaran: 0')
  end

  scenario 'asn with at least one sasaran' do
    user.sasarans.create!(sasaran_kinerja: 'Test Sasaran')
    visit root_path
    fill_in "user_login", with: user.email
    fill_in "password", with: user.password
    click_button "Sign in"
    expect(page).to have_content('Sasaran Kinerja / Rencana Kinerja')
    expect(page).to have_content('Jumlah sasaran: 1')
  end
end
