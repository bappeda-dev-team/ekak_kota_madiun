require 'rails_helper'

RSpec.describe 'Tim View', type: :feature do
  context "index" do
    before(:each) do
      create(:tim, nama_tim: 'Tim Kota', jenis: 'Kota', tahun: '2023')
      create(:tim, nama_tim: 'Tim Kota 2', jenis: 'Kota', tahun: '2023')

      user = create(:super_admin)
      login_as user
      visit tims_path
    end

    it "render list of tims" do
      expect(page).to have_title('Daftar Tim')
      expect(page).to have_content('Tim Kota')
      expect(page).to have_content('Tim Kota 2')
    end

    it 'have new button with remote true' do
      expect(page).to have_link('Tambah Tim', href: new_tim_path)
      expect(page).to have_selector('a[data-remote="true"]')
    end

    it "spawn modal form on new button click" do
      find_link('Tambah Tim').click
      page.should have_content('Form')
    end
  end
end
