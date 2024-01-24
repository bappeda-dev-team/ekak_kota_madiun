require 'rails_helper'

RSpec.feature "Substansi Renstra menu on sidebar", type: :feature do
  it 'display substansi renstra for super_admin' do
    user = create(:super_admin)
    login_as user

    visit root_path
    expect(page).to have_content('Substansi Renstra')
  end
  it 'display substansi renstra for reviewer' do
    user = create(:reviewer)
    login_as user

    visit root_path
    expect(page).to have_content('Substansi Renstra')
  end

  it 'display substansi renstra for admin opd' do
    user = create(:admin_opd)
    login_as user

    visit root_path
    expect(page).to have_content('Substansi Renstra')
  end
  it 'display substansi renstra for asn' do
    user = create(:asn)
    login_as user

    visit root_path
    expect(page).to have_content('Substansi Renstra')
  end

  it 'should not display substansi renstra for non_aktif' do
    user = create(:non_aktif)
    login_as user

    visit root_path
    expect(page).to_not have_content('Substansi Renstra')
  end
end
