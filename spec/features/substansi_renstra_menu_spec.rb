require 'rails_helper'

RSpec.feature "Substansi Renstra menu on sidebar", type: :feature do
  context 'display by user' do
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

  context 'menu substansi renstra' do
    it 'should have Bab 1 - 7 menu' do
      user = create(:super_admin)
      login_as user

      visit root_path

      find('span.sidebar-text', text: 'Substansi Renstra').click

      expect(page).to have_content('Bab 1')
      expect(page).to have_content('Bab 2')
      expect(page).to have_content('Bab 3')
      expect(page).to have_content('Bab 4')
      expect(page).to have_content('Bab 5')
      expect(page).to have_content('Bab 6')
      expect(page).to have_content('Bab 7')
    end
  end
end
