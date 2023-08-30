require 'rails_helper'

RSpec.feature "PohonTematiks", type: :feature do
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
                   role: 'pohon_kota')

    visit kota_pohon_kinerja_index_path

    within('.card-body') do
      select2 'test tematik 1', from: 'Tematik', search: 'test'
      click_on "Filter"
    end
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

  scenario "render sub sub tematik", :js do
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

    expect(page).to have_content('Sub Sub-Tematik Kota')
    expect(page).to have_content('test sub sub tematik')
  end
end
