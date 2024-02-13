require 'rails_helper'

RSpec.describe "Substansi Renstra Bab 2", type: :feature do
  let(:user) { create(:super_admin) }
  let(:opd) { user.opd }

  def open_aset_kepegawaian_page
    login_as user

    visit root_path
    create_cookie('opd', 'test_opd')
    create_cookie('tahun', '2025')
    # page.driver.browser.set_cookie 'opd=test_opd'
    # page.driver.browser.set_cookie 'tahun=2025'

    find('span.sidebar-text', text: 'Substansi Renstra').click
    find('span.sidebar-text', text: 'Bab 2').click

    click_on 'Kepegawaian dan Aset'
    expect(page).to have_title('Bab 2 - Kepegawaian dan Aset')
    expect(page).to have_selector('li.breadcrumb-item', text: 'Substansi Renstra')
    expect(page).to have_selector('li.breadcrumb-item', text: 'Bab 2')
    expect(page).to have_selector('li.breadcrumb-item.active', text: 'Kepegawaian dan Aset')
    expect(page).to have_content('Laporan Kepegawaian dan Aset')
    expect(page).to have_content(user.opd.nama_opd)
    expect(page).to have_content('2025')
  end

  context 'bab 2' do
    it 'show Evaluasi Renstra Item' do
      login_as user

      visit root_path
      # create_cookie('opd', 'test_opd')
      # create_cookie('tahun', '2025')
      page.driver.browser.set_cookie 'opd=test_opd'
      page.driver.browser.set_cookie 'tahun=2025'

      find('span.sidebar-text', text: 'Substansi Renstra').click
      find('span.sidebar-text', text: 'Bab 2').click

      click_on 'Evaluasi Renstra'
      expect(page).to have_content('Laporan Evaluasi Renstra - Periode 2019-2024')
    end
  end

  context 'on already inputted kependidikan and pendidikan terakhir in jabatan opd' do
    let(:kepala_opd) do
      create(:jabatan, kode_opd: opd.kode_unik_opd,
                       nama_jabatan: 'Kepala OPD')
    end
    let(:sekretaris) do
      create(:jabatan, kode_opd: opd.kode_unik_opd,
                       nama_jabatan: 'Sekretaris OPD')
    end
    let(:fungsional1) do
      create(:jabatan, kode_opd: opd.kode_unik_opd,
                       nama_jabatan: 'Fungsional 1')
    end
    let(:staff1) do
      create(:jabatan, kode_opd: opd.kode_unik_opd,
                       nama_jabatan: 'Staff 1')
    end

    it 'show Kepegawaian Item', js: true do
      kepala_opd
      sekretaris
      fungsional1
      staff1
      kepegawaians = opd.jabatans.map do |jabatan|
        Jabatan::STATUS_KEPEGAWAIAN.each do |pegawai|
          Kepegawaian.create(opd: opd, jabatan: jabatan,
                             tahun: '2025',
                             status_kepegawaian: pegawai,
                             jumlah: 5)
        end
      end.flatten

      magister = PendidikanTerakhir.create(kepegawaian: kepala_opd.kepegawaians.first,
                                           pendidikan: 'S2/S3')

      sarjana = PendidikanTerakhir.create(kepegawaian: fungsional1.kepegawaians.first,
                                          pendidikan: 'D4/S1')
      magister2 = PendidikanTerakhir.create(kepegawaian: fungsional1.kepegawaians.second,
                                            pendidikan: 'S2/S3')
      d3 = PendidikanTerakhir.create(kepegawaian: fungsional1.kepegawaians.last,
                                     pendidikan: 'D1/D3')

      sd_smp = PendidikanTerakhir.create(kepegawaian: staff1.kepegawaians.third,
                                         pendidikan: 'SD/SMP')
      sma = PendidikanTerakhir.create(kepegawaian: staff1.kepegawaians.first,
                                      pendidikan: 'SMA')
      d3_staff = PendidikanTerakhir.create(kepegawaian: staff1.kepegawaians.first,
                                           pendidikan: 'D1/D3')
      sarjana2 = PendidikanTerakhir.create(kepegawaian: staff1.kepegawaians.last,
                                           pendidikan: 'D4/S1')

      open_aset_kepegawaian_page
      expect(page).to have_selector('td[data-pendidikan="true"]', count: 8)
    end
  end

  context 'on blank data' do
    it 'show jabatan in opd without kepegawaian', js: true do
      kepala_opd
      sekretaris
      fungsional1
      staff1

      open_aset_kepegawaian_page

      expect(page).to have_content(kepala_opd.nama_jabatan)
      expect(page).to have_content(sekretaris.nama_jabatan)
      expect(page).to have_content(fungsional1.nama_jabatan)
      expect(page).to have_content(staff1.nama_jabatan)
    end

    it 'show opd without jabatan', js: true do
      open_aset_kepegawaian_page

      expect(page).to_not have_content(kepala_opd.nama_jabatan)
    end
  end
end
