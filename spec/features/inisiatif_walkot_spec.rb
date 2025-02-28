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

  def sign_in_and_pick_tahun(user, nama_opd: '', tahun: '2025')
    visit root_path

    # sign in
    fill_in 'user_login', with: user.nik
    fill_in 'password', with: user.password
    click_on 'Sign in'

    within(".filter-form") do
      select2 tahun, xpath: '//*[@id="navbarSupportedContent"]/ul/li[1]/form/div/span[3]'
      select2 nama_opd, xpath: '//*[@id="navbarSupportedContent"]/ul/li[1]/form/div/span[1]'
      click_on 'Aktifkan'
    end
    # click the notification
    click_on 'Ok'
  end

  scenario 'Admin kota create inisiatif walikota with lead opd successfully', js: true do
    setup_user_misi_and_tahun
    sign_in_and_pick_tahun(admin_kota, nama_opd: bappeda.nama_opd)
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

  let(:bagor) do
    create(:opd,
           nama_opd: 'Bagian Organisasi',
           kode_opd: '456',
           kode_unik_opd: '4.01.0.00.0.00.01.0002',
           is_kota: false,
           is_bagian: true,
           lembaga: kota_madiun)
  end

  scenario 'inisiatif walikota pick opd kolab', js: true do
    setup_user_misi_and_tahun
    create_inisiatif_walkot

    sign_in_and_pick_tahun(admin_kota, nama_opd: bappeda.nama_opd)
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

    bagor

    click_on 'Tambah Kolaborator'

    fill_in 'Urutan', with: '1'
    select2 'Bagian Organisasi', from: 'Opd kolaborator'
    fill_in 'Keterangan', with: 'Kolaborasi SAKIP'
    click_on 'Simpan Kolab'

    click_on 'Ok'

    page.execute_script("document.querySelector('div.table-responsive').scrollLeft += 500;")
    # to identify absent of rekin by kolaborator
    expect(page).to have_selector('table#kolab_1.table-danger')
    within('table#kolab_1.table-danger') do
      assert_text 'OPD (Anggota)'
      assert_text 'Bagian Organisasi'
      assert_text 'Jumlah Rekin'
      # to identify absent of rekin by kolaborator
      expect(page).to have_selector('td.jumlah-rekin-kolab', text: '0')
      # keterangan
      assert_text 'Kolaborasi SAKIP'
    end
  end

  let(:program_unggulan) do
    create(:inovasi,
           tahun: '2025',
           opd: bappeda.kode_unik_opd,
           usulan: 'Meningkatkan pembelajaran dengan papan tulis digital pada SD dan SMP Negeri Kota Madiun',
           misi: misi,
           manfaat: asta_karya.asta_karya,
           tag: '100 Hari Kerja',
           tag_active: true,
           is_active: true,
           uraian_tag: 'XX-Papan-Tulis',
           uraian: 'YY-Uraian-Umum')
  end
  let(:opd_kolab) do
    # preparation
    # kolab with opd bagor
    create(:kolab,
           kolabable_type: 'Inovasi',
           kolabable_id: program_unggulan.id,
           jenis: 'Dari-Kota',
           tahun: '2025',
           status: 'Anggota',
           kode_unik_opd: bagor.kode_unik_opd,
           keterangan: 'Kolaborasi SAKIP')
  end
  let(:asn_c) do
    create(:eselon_4, nik: '19988822211132187',
                      nama: 'Wadi Ah',
                      email: '19988822211132187@test.com',
                      opd: bagor)
  end
  let(:rekin_eselon4) do
    strategi = create(:strategi, tahun: '2025', role: 'eselon_4',
                                 nip_asn: asn_c.nip_asn,
                                 opd: bagor)
    program_kegiatan = create(:program_kegiatan,
                              opd: bagor)

    rekin_asn = create(:sasaran,
                       sasaran_kinerja: 'sasaran-program-unggulan',
                       user: asn_c,
                       tahun: '2025',
                       id_rencana: '123',
                       program_kegiatan: program_kegiatan,
                       strategi: strategi)
    indikator_sasaran = create(:indikator_sasaran, sasaran: rekin_asn)
    create(:manual_ik, indikator_sasaran: indikator_sasaran)
    create(:rincian, sasaran: rekin_asn)
    create(:tahapan, sasaran: rekin_asn, id_rencana_aksi: 'test-a')
    create(:aksi, id_rencana_aksi: 'test-a', target: 100, bulan: 12)
  end

  scenario 'User Open Usulan Page and found it blank before kolab', js: true do
    setup_user_misi_and_tahun
    asn_c
    sign_in_and_pick_tahun(asn_c, nama_opd: bagor.nama_opd)
    # expect(page).to have_text('Kota Madiun')
    find('span.sidebar-text', text: 'Perencanaan').click
    find('span.sidebar-text', text: 'Usulan').click
    find('span.sidebar-text', text: 'Inisiatif Walikota').click
    expect(page).to have_text('Usulan Inisiatif Walikota Tahun 2025')
    expect(page).to_not have_text('Tambah Usulan')
    expect(page).to have_css('tbody tr', count: 0)
  end

  context 'Called for Kolab', js: true do
    before(:each) do
      setup_user_misi_and_tahun
      program_unggulan
      opd_kolab
      asn_c
      rekin_eselon4
      sign_in_and_pick_tahun(asn_c, nama_opd: bagor.nama_opd)
      expect(page).to have_text('Kota Madiun')
    end

    scenario 'Program unggulan showed at Perencanaan / Usulan / Insiatif Walikota Menu', js: true do
      # find rencana kinerja / usulan / insiatif walikota
      find('span.sidebar-text', text: 'Perencanaan').click
      find('span.sidebar-text', text: 'Usulan').click
      find('span.sidebar-text', text: 'Inisiatif Walikota').click
      expect(page).to have_text('Usulan Inisiatif Walikota Tahun 2025')
      expect(page).to have_text(program_unggulan.usulan)
    end

    scenario 'User add program unggulan in their standard rekin', js: true do
      # open rekin
      find('span.sidebar-text', text: 'Perencanaan').click
      find('span.sidebar-text', text: 'Rencana Kinerja').click

      click_on('Input Rincian')
      expect(page).to have_text('sasaran-program-unggulan')

      # scroll to Usulan Inisiatif
      page.execute_script("window.scrollTo(0, 1500)")
      expect(page).to have_text('Usulan Inisiatif')

      # choose program unggulan
      select2 program_unggulan.usulan, xpath: '/html/body/main/div/div[5]/div[2]/form/div[1]/span'
      # click save
      find(:xpath, '/html/body/main/div/div[5]/div[2]/form/div[2]/input').click

      click_on 'OK'

      expect(page).to have_text(program_unggulan.usulan)
    end

    scenario 'User select program unggulan and it update count in Laporan / Usulan / Inisiatif Walikota', js: true do
      # open rekin
      find('span.sidebar-text', text: 'Perencanaan').click
      find('span.sidebar-text', text: 'Rencana Kinerja').click

      click_on('Input Rincian')
      expect(page).to have_text('sasaran-program-unggulan')
      select2 program_unggulan.usulan, xpath: '/html/body/main/div/div[5]/div[2]/form/div[1]/span'
      find(:xpath, '/html/body/main/div/div[5]/div[2]/form/div[2]/input').click
      click_on 'OK'

      # assert
      find('span.sidebar-text', text: 'Laporan').click
      find('span.sidebar-text', text: 'Usulan').click
      find('span.sidebar-text', text: 'Inisiatif Walikota').click

      expect(page).to have_selector('table#kolab_1.table-success')
      expect(page).to have_selector('.jumlah-rekin-kolab', text: '1')
    end

    scenario 'inputted rekin not chaning the pengusul in Usulan / Inisiatif Walikota', js: true do
      # open rekin
      find('span.sidebar-text', text: 'Perencanaan').click
      find('span.sidebar-text', text: 'Rencana Kinerja').click

      click_on('Input Rincian')
      expect(page).to have_text('sasaran-program-unggulan')
      select2 program_unggulan.usulan, xpath: '/html/body/main/div/div[5]/div[2]/form/div[1]/span'
      find(:xpath, '/html/body/main/div/div[5]/div[2]/form/div[2]/input').click
      click_on 'OK'

      # assert
      find('span.sidebar-text', text: 'Perencanaan').click
      find('span.sidebar-text', text: 'Usulan').click
      find('span.sidebar-text', text: 'Inisiatif Walikota').click

      expect(page).to have_selector('.pengusul', text: 'Kota')
    end
  end
end
