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
    click_on 'Tambah Tujuan Kota'

    select2 'ContohVisi', from: 'Visi'
    select2 'ContohMisi', from: 'Misi'
    select2 '2025', from: 'Periode'
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

    click_on 'Ok'

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
  scenario 'edit tujuan kota oleh admin kota', js: true do
    # Capybara.default_max_wait_time = 10
    admin_kota
    periode
    tahun_dua_lima
    visi = create(:visi, visi: 'ContohVisi',
                         tahun_awal: '2025',
                         tahun_akhir: '2029',
                         lembaga: admin_kota.opd.lembaga)
    misi = create(:misi, visi: visi, misi: 'ContohMisi',
                         tahun_awal: '2025',
                         tahun_akhir: '2029',
                         lembaga: admin_kota.opd.lembaga)
    tema = create(:tematik, tema: 'test tematik 1',
                            keterangan: 'test tema')
    pohon = create(:pohon, pohonable_type: 'Tematik',
                           pohonable_id: tema.id,
                           role: 'pohon_kota',
                           tahun: '2025')
    tujuan_kota = create(:tujuan_kota,
                         visi_id: visi.id,
                         misi_id: misi.id,
                         tahun_awal: '2025',
                         tahun_akhir: '2029',
                         tujuan: 'tujuan kota x',
                         pohon_id: pohon.id,
                         id_tujuan: 'test-id-tujuan')

    indikator_tujuan = create(:indikator,
                              indikator: 'test-indikator',
                              kode: tujuan_kota.id_tujuan,
                              rumus_perhitungan: 'rumus-X',
                              sumber_data: 'data-T')
    # target indikator 25 26
    create(:target,
           target: 1003,
           satuan: '%',
           tahun: '2025',
           indikator_id: indikator_tujuan.id)
    create(:target,
           target: 1004,
           satuan: 'uvw',
           tahun: '2026',
           indikator_id: indikator_tujuan.id)

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
    expect(page).to have_text('tujuan kota x')
    expect(page).to have_text('test-indikator')
    expect(page).to have_text('rumus-X')
    expect(page).to have_text('data-T')
    expect(page).to have_text('1003')
    expect(page).to have_text('%')
    expect(page).to have_text('1004')
    expect(page).to have_text('uvw')

    click_on 'Edit'
    fill_in 'Tujuan', with: 'tujuanTelahDiEdit'
    find('#tujuan_kota_indikator_tujuans_attributes_0_targets_attributes_0_target').set('20')
    find('#tujuan_kota_indikator_tujuans_attributes_0_targets_attributes_0_satuan').set('persen')
    find('#tujuan_kota_indikator_tujuans_attributes_0_targets_attributes_1_target').set('30')
    find('#tujuan_kota_indikator_tujuans_attributes_0_targets_attributes_1_satuan').set('xvw')
    click_on 'Simpan Perubahan Tujuan kota'

    click_on 'Ok'

    expect(page).to have_text('tujuanTelahDiEdit')
    expect(page).to have_text('20')
    expect(page).to have_text('persen')
    expect(page).to have_text('30')
    expect(page).to have_text('xvw')
  end
  scenario 'hapus tujuan kota oleh admin kota', js: true do
    # Capybara.default_max_wait_time = 10
    admin_kota
    periode
    tahun_dua_lima
    visi = create(:visi, visi: 'ContohVisi',
                         tahun_awal: '2025',
                         tahun_akhir: '2029',
                         lembaga: admin_kota.opd.lembaga)
    misi = create(:misi, visi: visi, misi: 'ContohMisi',
                         tahun_awal: '2025',
                         tahun_akhir: '2029',
                         lembaga: admin_kota.opd.lembaga)
    tema = create(:tematik, tema: 'test tematik 1',
                            keterangan: 'test tema')
    pohon = create(:pohon, pohonable_type: 'Tematik',
                           pohonable_id: tema.id,
                           role: 'pohon_kota',
                           tahun: '2025')
    tujuan_kota = create(:tujuan_kota,
                         visi_id: visi.id,
                         misi_id: misi.id,
                         tahun_awal: '2025',
                         tahun_akhir: '2029',
                         tujuan: 'tujuan kota x',
                         pohon_id: pohon.id,
                         id_tujuan: 'test-id-tujuan')

    indikator_tujuan = create(:indikator,
                              indikator: 'test-indikator',
                              kode: tujuan_kota.id_tujuan,
                              rumus_perhitungan: 'rumus-X',
                              sumber_data: 'data-T')
    # target indikator 25 26
    create(:target,
           target: 1003,
           satuan: '%',
           tahun: '2025',
           indikator_id: indikator_tujuan.id)
    create(:target,
           target: 1004,
           satuan: 'uvw',
           tahun: '2026',
           indikator_id: indikator_tujuan.id)

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
    expect(page).to have_text('tujuan kota x')

    click_on 'Hapus'

    click_on 'Ya'

    click_on 'Ok'

    expect(page).to_not have_text('tujuan kota x')
  end
end
