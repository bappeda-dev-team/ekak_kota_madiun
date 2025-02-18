require 'rails_helper'

RSpec.describe "Tujuan Kota", type: :feature do
  let(:admin_kota) { create(:super_admin) }
  let(:tahun_dua_lima) { create(:dua_lima) }
  let(:periode) { create(:base_periode) }

  scenario 'input tujuan kota baru oleh admin kota', js: true do
    # Capybara.default_max_wait_time = 10
    admin_kota
    periode
    tahun_dua_lima
    visi = create(:visi, visi: 'ContohVisi',
                         tahun_awal: '2025',
                         tahun_akhir: '2029',
                         lembaga: admin_kota.opd.lembaga)
    create(:misi, visi: visi, misi: 'ContohMisi',
                  tahun_awal: '2025',
                  tahun_akhir: '2029',
                  lembaga: admin_kota.opd.lembaga)
    tema = create(:tematik, tema: 'test tematik 1',
                            keterangan: 'test tema')
    create(:pohon, pohonable_type: 'Tematik',
                   pohonable_id: tema.id,
                   role: 'pohon_kota',
                   tahun: '2025')

    visit root_path

    fill_in 'user_login', with: admin_kota.nik
    fill_in 'password', with: admin_kota.password
    click_on 'Sign in'

    # create_cookie('opd', '2.16.2.20.2.21.04.000')
    # create_cookie('tahun', '2025')
    within(".filter-form") do
      select2 '2025', xpath: '//*[@id="navbarSupportedContent"]/ul/li[1]/form/div/span[3]'
      select2 'Dinas', xpath: '//*[@id="navbarSupportedContent"]/ul/li[1]/form/div/span[1]'
      click_on 'Aktifkan'
    end
    # click the notification
    click_on 'Ok'
    expect(page).to have_text('Kota Madiun')
    visit root_path

    find('span.sidebar-text', text: 'Perencanaan Kota').click
    find('span.sidebar-text', text: 'Tujuan Kota').click
    expect(page).to have_css('.loader')

    page.has_css?('#tujuan-kota-card')

    expect(page).to have_text('Tujuan Kota Periode 2025 - 2029')
    click_on 'Buat Tujuan Kota Baru'

    select2 'ContohVisi', from: 'Visi'
    select2 'ContohMisi', from: 'Misi'
    select2 'test tematik 1', from: 'Tematik'
    fill_in 'Tujuan', with: 'testTujuan'
    fill_in 'Indikator', with: 'indikatorTujuan'
    fill_in 'Rumus perhitungan', with: 'rumusXXX'
    fill_in 'Sumber data', with: 'sumberDataXYZ'
    find('#tujuan_kota_indikator_tujuans_attributes_0_targets_attributes_0_target').set('20')
    find('#tujuan_kota_indikator_tujuans_attributes_0_targets_attributes_0_satuan').set('%')
    find('#tujuan_kota_indikator_tujuans_attributes_0_targets_attributes_1_target').set('30')
    find('#tujuan_kota_indikator_tujuans_attributes_0_targets_attributes_1_satuan').set('%')
    click_on 'Simpan Tujuan kota'

    click_on 'OK'

    expect(page).to have_text('ContohVisi')
    expect(page).to have_text('ContohMisi')
    expect(page).to have_text('test tematik 1')
    expect(page).to have_text('testTujuan')
    expect(page).to have_text('indikatorTujuan')
    expect(page).to have_text('rumusXXX')
    expect(page).to have_text('sumberDataXYZ')
    expect(page).to have_text('20')
    expect(page).to have_text('%')
    expect(page).to have_text('30')
    expect(page).to have_text('%')
  end
end
