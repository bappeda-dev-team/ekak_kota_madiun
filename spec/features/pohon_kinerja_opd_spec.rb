require 'rails_helper'

RSpec.feature "PohonKinerjaOpds", type: :feature do
  let(:user) { create(:super_admin) }

  def strategi_test
    strategi = create(:strategi,
                      type: 'StrategiPohon',
                      strategi: 'test 1',
                      opd_id: user.opd.id,
                      tahun: '2023',
                      nip_asn: '',
                      role: 'eselon_2')
    sasaran = create(:sasaran, user: nil, strategi_id: strategi.id, id_rencana: 'xx1', tahun: '2023')
    create(:indikator_sasaran, indikator_kinerja: 'test ind',
                               target: '100', satuan: '%',
                               sasaran_id: sasaran.id_rencana)
  end

  def strategi_pohon_test
    strategi = create(:strategi,
                      type: 'StrategiPohon',
                      strategi: 'test pohon 1',
                      opd_id: user.opd.id,
                      tahun: '2023',
                      nip_asn: '',
                      role: 'eselon_2')
    sasaran = create(:sasaran, user: nil, strategi_id: strategi.id, id_rencana: 'xx1', tahun: '2023')
    create(:indikator_sasaran, indikator_kinerja: 'test ind',
                               target: '100', satuan: '%',
                               sasaran_id: sasaran.id_rencana)
    create(:pohon, keterangan: 'test pohon', opd_id: user.opd.id, tahun: '2023',
                   pohonable_type: 'Strategi', pohonable_id: strategi.id, role: 'strategi_pohon_kota')
  end

  before(:each) do
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
    strategi_test
    visit manual_pohon_kinerja_index_path

    expect(page).to have_content('test 1')

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

  scenario "delete pokin opd", :js do
    strategi_test
    visit manual_pohon_kinerja_index_path

    expect(page).to have_content('test 1')

    within('.strategic-pohon') do
      within('.pohon-tombol') do
        click_on "Hapus"
      end
    end
    click_button "Ya"

    # sweetalert
    click_button "Ok"

    expect(page).not_to have_content("test 1")
  end

  scenario "setujui pohon kota", :js do
    strategi_pohon_test
    visit manual_pohon_kinerja_index_path

    expect(page).to have_content('Strategi - Kota')
    expect(page).to have_content('test pohon 1')

    click_on "Terima"
    click_button "Ya"

    # sweetalert
    click_button "Ok"

    expect(page).to have_css(".pohon-accepted")
  end
end
