require 'rails_helper'

RSpec.feature "Substansi Renstra Bab 1", type: :feature do
  let(:user) { create(:eselon_4, email: 'usulan@test.com', nik: '123_456') }
  let(:sasaran) { create(:complete_sasaran, user: user, tahun: '2025') }
  let(:mandatori) do
    create(:mandatori, peraturan_terkait: 'peraturan y',
                       uraian: 'dasar hukum x',
                       tahun: '2025',
                       sasaran_id: sasaran.id)
  end
  let(:usulan_mandatori) do
    create(:usulan, usulanable_id: mandatori.id,
                    usulanable_type: 'Mandatori',
                    sasaran_id: sasaran)
  end

  it 'show Dasar Hukum for selected opd and tahun' do
    login_as user

    visit root_path
    # create_cookie('opd', 'test_opd')
    # create_cookie('tahun', '2025')
    page.driver.browser.set_cookie 'opd=test_opd'
    page.driver.browser.set_cookie 'tahun=2025'

    usulan_mandatori

    find('span.sidebar-text', text: 'Substansi Renstra').click
    find('span.sidebar-text', text: 'Bab 1').click

    find('#substansi-renstra-bab-1-dasar-hukum').click
    expect(page).to have_title('Bab 1 - Dasar Hukum')
    expect(page).to have_selector('li.breadcrumb-item', text: 'Bab 1')
    expect(page).to have_text('Laporan Dasar Hukum')
    expect(page).to have_text('peraturan y')
    expect(page).to have_text('dasar hukum x')
  end

  it 'edit dasar hukum', js: true do
    login_as user

    visit root_path

    create_cookie('opd', 'test_opd')
    create_cookie('tahun', '2025')

    usulan_mandatori
    visit laporans_substansi_renstra_dasar_hukum_path
    click_on('Edit')

    fill_in('Peraturan terkait', with: 'editted')
    fill_in('Dasar hukum', with: 'editted-2')
    click_on('Simpan')

    click_on('Ok')

    expect(page).to have_text('editted')
    expect(page).to have_text('editted-2')
  end

  it 'hapus dasar hukum', js: true do
    login_as user

    visit root_path

    create_cookie('opd', 'test_opd')
    create_cookie('tahun', '2025')

    usulan_mandatori
    visit laporans_substansi_renstra_dasar_hukum_path
    click_on('Hapus')

    click_on('Ya')
    click_on('Ok')

    expect(page).to_not have_text('peraturan y')
    expect(page).to_not have_text('dasar hukum x')
  end
end
