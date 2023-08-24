require 'rails_helper'

RSpec.feature "PohonKinerjaOpds", type: :feature do
  before(:each) do
    user = create(:super_admin)

    login_as user

    # setup cookies
    visit root_path

    create_cookie('opd', 'test_opd')
    create_cookie('tahun', '2023')
  end

  scenario "create pokin opd", :js do
    visit manual_pohon_kinerja_index_path
    click_on "Strategi Baru"
    # form
    within('.strategi_pohon') do
      within('.pohon-body') do
        fill_in "Strategi", with: "contoh strategi"
        fill_in "Sasaran", with: "contoh sasaran"
        fill_in "Indikator kinerja", with: "Indikator strategi"
        fill_in "Target", with: "100"
        fill_in "Satuan", with: "%"
        click_on "Simpan Strategi pohon"
      end
    end

    # sweetalert
    click_button "Ok"

    expect(page).to have_content("contoh strategi")
    expect(page).to have_css(".strategic-pohon")
  end

  scenario "edit pokin opd", :js do
    visit manual_pohon_kinerja_index_path
    click_on "Strategi Baru"
    # form
    within('.strategi_pohon') do
      within('.pohon-body') do
        fill_in "Strategi", with: "contoh strategi"
        fill_in "Sasaran", with: "contoh sasaran"
        fill_in "Indikator kinerja", with: "Indikator strategi"
        fill_in "Target", with: "100"
        fill_in "Satuan", with: "%"
        click_on "Simpan Strategi pohon"
      end
    end

    # sweetalert
    click_button "Ok"

    within('.strategic-pohon') do
      within('.pohon-tombol') do
        click_on "Edit"
      end
      within('.pohon-body') do
        fill_in "Strategi", with: "edit contoh strategi"
        fill_in "Sasaran", with: "edit contoh sasaran"
        fill_in "Indikator kinerja", with: "edit Indikator strategi"
        fill_in "Target", with: "1100"
        fill_in "Satuan", with: "%"
        click_on "Simpan Perubahan Strategi pohon"
      end
    end

    # sweetalert
    click_button "Ok"

    expect(page).to have_content("edit contoh strategi")
    expect(page).to have_css(".strategic-pohon")
  end
end
