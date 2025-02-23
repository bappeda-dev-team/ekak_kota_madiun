require 'rails_helper'

RSpec.describe "Inisiatif Walikota", type: :feature do
  let(:kota_madiun) { create(:lembaga) }
  let(:kota) { create(:kota, lembaga: kota_madiun) }
  let(:visi) { create(:visi, lembaga: kota_madiun) }
  let(:misi) { create(:misi, visi: visi, lembaga: kota_madiun, misi: 'Meningkatkan pengembangan sumber daya manusia yangberkualitas dan berdaya saing global') }
  let(:bappeda) { create(:bappeda, lembaga: kota_madiun) }
  let(:admin_kota) { create(:super_admin, opd: bappeda) }
  let(:periode_rpjmd) { create(:periode_rpjmd) }
  let(:tahun_dua_lima) { create(:dua_lima, periode: periode_rpjmd) }
  # for filter
  let(:tahun_anggaran) { create(:base_periode) }
  let(:asta_karya) { create(:program_unggulan, lembaga: kota_madiun, asta_karya: 'Madiun Kota Pintar') }

  def setup_user_misi_and_tahun
    admin_kota
    tahun_dua_lima
    tahun_anggaran
    misi
    asta_karya
  end

  def sign_in_and_pick_tahun
    visit root_path

    # sign in
    fill_in 'user_login', with: admin_kota.nik
    fill_in 'password', with: admin_kota.password
    click_on 'Sign in'

    within(".filter-form") do
      select2 '2025', xpath: '//*[@id="navbarSupportedContent"]/ul/li[1]/form/div/span[3]'
      select2 bappeda.nama_opd, xpath: '//*[@id="navbarSupportedContent"]/ul/li[1]/form/div/span[1]'
      click_on 'Aktifkan'
    end
    # click the notification
    click_on 'Ok'
  end

  scenario 'Admin kota create inisiatif walikota with lead opd successfully', js: true do
    setup_user_misi_and_tahun
    sign_in_and_pick_tahun
    expect(page).to have_text('Kota Madiun')

    # open data master / usulans / inisiatif walikota
    find('span.sidebar-text', text: 'Data Master').click
    find('span.sidebar-text', text: 'Usulan').click
    find('span.sidebar-text', text: 'Inisiatif Walikota').click

    expect(page).to have_text('Usulan Inisiatif Walikota Tahun 2025')

    click_on 'Tambah Usulan'

    select2 bappeda.nama_opd, from: 'OPD Lead'
    fill_in 'Program Unggulan Walikota', with: 'Meningkatkan pembelajaran dengan papan tulis digital pada SD dan SMP Negeri Kota Madiun'
    select2 'Meningkatkan', from: 'Misi'
    select2 'Madiun', from: 'ASTA KARYA'
    select2 '100 Hari', xpath: '/html/body/div[2]/div/div/div[2]/form/div[7]/span'
    check 'Tagging Aktif?'
    fill_in 'Uraian 100 Hari Kerja', with: 'XX-Papan-Tulis'
    fill_in 'Uraian Umum', with: 'YY-Uraian-Umum'
    click_on 'Simpan Inisiatif Walikota baru'

    click_on 'Ok'

    expect(page).to have_text('Meningkatkan pembelajaran dengan papan tulis digital pada SD dan SMP Negeri Kota Madiun')
    expect(page).to have_text('Madiun Kota Pintar')
    expect(page).to have_text('Meningkatkan pengembangan sumber daya manusia yangberkualitas dan berdaya saing global')
    expect(page).to have_text('Badan Perencanaan, Penelitian dan Pengembangan Daerah')
    expect(page).to have_text('XX-Papan-Tulis')
    expect(page).to have_text('YY-Uraian-Umum')
  end

  let(:create_inisiatif_walkot) do
    create(:inovasi,
           tahun: '2025',
           opd: bappeda.kode_unik_opd,
           usulan: 'Meningkatkan pembelajaran dengan papan tulis digital pada SD dan SMP Negeri Kota Madiun',
           misi: misi,
           manfaat: asta_karya.asta_karya,
           tag: '100 Hari Kerja',
           tag_active: true,
           uraian_tag: 'XX-Papan-Tulis',
           uraian: 'YY-Uraian-Umum')
  end

  scenario 'inisiatif walikota pick opd kolab', js: true do
    setup_user_misi_and_tahun
    create_inisiatif_walkot

    sign_in_and_pick_tahun
    expect(page).to have_text('Kota Madiun')

    # find laporan / usulan / insiatif walikota
    find('span.sidebar-text', text: 'Laporan').click
    find('span.sidebar-text', text: 'Usulan').click
    find('span.sidebar-text', text: 'Inisiatif Walikota').click

    expect(page).to have_text('Meningkatkan pembelajaran dengan papan tulis digital pada SD dan SMP Negeri Kota Madiun')
    expect(page).to have_text('Madiun Kota Pintar')
    expect(page).to have_text('Meningkatkan pengembangan sumber daya manusia yangberkualitas dan berdaya saing global')
    expect(page).to have_text('Badan Perencanaan, Penelitian dan Pengembangan Daerah (Lead)')
    # rekin kosong indicator
    expect(page).to have_selector('tr.rekins>td.table-danger')
    expect(page).to have_selector('tr.rekins', text: '')
    page.execute_script("document.querySelector('div.table-responsive').scrollLeft += 2000;")
    # end
    expect(page).to have_text('YY-Uraian-Umum')
    expect(page).to have_link(text: 'Tambah Kolaborator')
  end
end
