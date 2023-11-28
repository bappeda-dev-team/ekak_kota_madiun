require 'rails_helper'

RSpec.describe "PohonTematiks", type: :system do
  let(:user) { create(:super_admin) }

  before(:each) do
    login_as user

    # setup cookies
    visit root_path

    create_cookie('opd', 'test_opd')
    create_cookie('tahun', '2023')
  end

  scenario "render pohon tematik", :js do
    tema = create(:tematik, tema: 'test tematik 1',
                            keterangan: 'test tema')
    create(:pohon, pohonable_type: 'Tematik',
                   pohonable_id: tema.id,
                   role: 'pohon_kota',
                   tahun: '2023')

    visit kota_pohon_kinerja_index_path

    select2 'test tematik 1', from: 'Tematik', search: true
    click_on "Filter"
    # within('.card-body') do
    # end
    expect(page).to have_content('Tematik Kota')
    expect(page).to have_content('test tematik 1')
    expect(page).to have_content('test tema')
  end

  scenario "render sub tematik", :js do
    tema = create(:tematik, tema: 'test tematik 1',
                            keterangan: 'test tema')

    sub_tema = create(:tematik, tema: 'test sub tematik',
                                type: 'SubTematik',
                                tematik_ref_id: tema.id,
                                keterangan: 'test sub tema')

    pohon_tema = create(:pohon, pohonable_type: 'Tematik',
                                pohonable_id: tema.id,
                                tahun: '2023',
                                keterangan: 'test pohon tema',
                                role: 'pohon_kota')

    create(:pohon, pohonable_type: 'SubTematik',
                   pohonable_id: sub_tema.id,
                   pohon_ref_id: pohon_tema.id,
                   keterangan: 'test pohon sub',
                   tahun: '2023',
                   role: 'sub_pohon_kota')

    visit kota_pohon_kinerja_index_path

    within('.card-body') do
      select2 'test tematik 1', from: 'Tematik', search: 'test'
      click_on "Filter"
    end

    expect(page).to have_content('Sub-Tematik Kota')
    expect(page).to have_content('test sub tematik')
    expect(page).to have_content('test sub tema')
  end

  context "sub sub tematik" do
    before(:each) do
      tema = create(:tematik, tema: 'test tematik 1',
                              keterangan: 'test tema')

      sub_tema = create(:tematik, tema: 'test sub tematik',
                                  type: 'SubTematik',
                                  tematik_ref_id: tema.id,
                                  keterangan: 'test sub tema')

      sub_sub_tema = create(:tematik, tema: 'test sub sub tematik',
                                      type: 'SubSubTematik',
                                      tematik_ref_id: sub_tema.id,
                                      keterangan: 'test sub tema')

      pohon_tema = create(:pohon, pohonable_type: 'Tematik',
                                  pohonable_id: tema.id,
                                  tahun: '2023',
                                  keterangan: 'test pohon tema',
                                  role: 'pohon_kota')

      pohon_sub = create(:pohon, pohonable_type: 'SubTematik',
                                 pohonable_id: sub_tema.id,
                                 pohon_ref_id: pohon_tema.id,
                                 keterangan: 'test pohon sub',
                                 tahun: '2023',
                                 role: 'sub_pohon_kota')

      create(:pohon, pohonable_type: 'SubSubTematik',
                     pohonable_id: sub_sub_tema.id,
                     pohon_ref_id: pohon_sub.id,
                     keterangan: 'test sub sub',
                     tahun: '2023',
                     role: 'sub_sub_pohon_kota')

      visit kota_pohon_kinerja_index_path

      within('.card-body') do
        select2 'test tematik 1', from: 'Tematik', search: 'test'
        click_on "Filter"
      end

      click_on "Tampilkan"
    end

    scenario "render sub sub tematik", :js do
      expect(page).to have_content('Sub Sub-Tematik Kota')
      expect(page).to have_content('test sub sub tematik')
    end

    scenario 'new sub sub tematik', :js do
      click_on "Sub Sub"
      within('.form-sub-sub-tematik') do
        fill_in 'sub_sub_tematik[tema]', with: 'Test sub sub-tematik'
        fill_in 'Indikator', with: 'Indikator a'
        fill_in 'Target', with: '100'
        fill_in 'Satuan', with: '%'
        fill_in 'Keterangan', with: 'keterangan sub sub'
        click_on 'Simpan'
      end

      click_button "Ok"

      expect(page).to have_content('Test sub sub-tematik')
      expect(page).to have_content('keterangan sub sub')
    end

    scenario 'edit sub sub tematik', :js do
      click_on "Sub Sub"
      within('.form-sub-sub-tematik') do
        fill_in 'sub_sub_tematik[tema]', with: 'Test sub sub-tematik'
        fill_in 'Indikator', with: 'Indikator a'
        fill_in 'Target', with: '100'
        fill_in 'Satuan', with: '%'
        fill_in 'Keterangan', with: 'keterangan sub sub'
        click_on 'Simpan'
      end

      click_button "Ok"

      within all('.action-sub-sub-tematik').last do
        click_on 'Edit'
      end

      within('.form-sub-sub-tematik') do
        fill_in 'sub_sub_tematik[tema]', with: 'update sub sub-tematik'
        fill_in 'Indikator', with: 'ind a'
        fill_in 'Target', with: '100'
        fill_in 'Satuan', with: '%'
        fill_in 'Keterangan', with: 'ket sub sub'
        click_on 'Simpan'
      end

      click_button "Ok"

      expect(page).to have_content 'update sub sub-tematik'
      expect(page).to have_content 'ind a'
      expect(page).to have_content 'ket sub sub'
    end

    scenario 'strategic dibawah sub sub tematik', :js do
      within all('.pohon-foot').last do
        click_on "Tampilkan"
        click_on "Strategic"
      end

      within('.form-strategi-tematik') do
        select2 'Komunikasi', from: 'Opd', search: 'komunikasi'
        fill_in 'strategi[strategi]', with: 'strategi a'
        fill_in 'Indikator', with: 'ind as'
        fill_in 'Target', with: '100'
        fill_in 'Satuan', with: '%'
        fill_in 'strategi[keterangan]', with: 'kk'
        click_on 'Simpan'
      end

      click_button "Ok"

      expect(page).to have_content 'strategi a'

      within all('.pohon-tombol').last do
        click_on "Edit"
      end

      within('.form-strategi-tematik') do
        # select2 'Komunikasi', from: 'Opd', search: 'komunikasi'
        fill_in 'strategi[strategi]', with: 'strategi edit'
        fill_in 'Indikator', with: 'ind edit'
        fill_in 'Target', with: '100'
        fill_in 'Satuan', with: '%'
        fill_in 'strategi[keterangan]', with: 'kk'
        click_on 'Simpan'
      end

      click_button "Ok"

      expect(page).to have_content 'strategi edit'
    end
  end
end
