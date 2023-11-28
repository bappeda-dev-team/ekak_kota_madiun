require 'rails_helper'

# TODO: change test to check class rather than content
RSpec.describe 'Tim View', type: :system do
  before(:each) do
    create(:tim, nama_tim: 'Tim Kota', jenis: 'Kota', tahun: '2023')
    create(:tim, nama_tim: 'Tim Kota 2', jenis: 'Kota', tahun: '2023')

    user = create(:super_admin)
    login_as user
    visit root_path
    create_cookie('opd', 'test_opd')
    create_cookie('tahun', '2025')
  end

  context "index" do
    before(:each) do
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

    it 'have edit button' do
      expect(page).to have_link('Edit Tim', href: edit_tim_path(Tim.first))
    end

    it 'have delete button' do
      expect(page).to have_link('Hapus Tim', href: tim_path(Tim.first))
    end

    it 'can delete item', :js do
      tim_contoh = Tim.last
      click_link('Hapus Tim', href: tim_path(tim_contoh))
      expect(page).to have_selector('div.swal2-container')
      within('div.swal2-container') do
        expect(page).to have_content("Hapus #{tim_contoh}?")
        click_on "Ya"
      end
      visit tims_path
      expect(page).not_to have_content(tim_contoh)
    end

    it "spawn modal form on new button click", :js do
      expect(page).to have_link('Tambah Tim', href: new_tim_path)
      find_link('Tambah Tim').click
      within('#form-modal') do
        expect(page).to have_content('Form')
        expect(page).to have_selector('form[data-controller="form-ajax"][data-remote="true"]')
      end
    end
  end

  context "form" do
    it "save with new form" do
      visit new_tim_path
      fill_in "Nama tim", with: "Tim Contoh"
      fill_in "Jenis", with: "Kota"
      fill_in "Tahun", with: "2023"
      fill_in "Keterangan", with: "Keterangan Contoh"
      click_on "Simpan Tim"

      visit tims_path
      expect(page).to have_content('Tim Contoh')
    end

    it "can edit existing data" do
      visit edit_tim_path(Tim.first)
      fill_in "Nama tim", with: "Tim Contoh Edit"
      click_on "Simpan Perubahan Tim"

      visit tims_path
      expect(page).to have_content('Tim Contoh Edit')
    end
  end
end
