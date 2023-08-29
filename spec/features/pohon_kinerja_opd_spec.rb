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

  def tactical_test
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
    tactical = create(:strategi,
                      type: 'StrategiPohon',
                      strategi: 'test tactical',
                      opd_id: user.opd.id,
                      tahun: '2023',
                      nip_asn: '',
                      role: 'eselon_3',
                      strategi_ref_id: strategi.id)
    sasaran = create(:sasaran, user: nil, strategi_id: tactical.id, id_rencana: 'xx2', tahun: '2023')
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

  def tactical_pohon_test
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
    pohon_strategi = create(:pohon, keterangan: 'test pohon', opd_id: user.opd.id, tahun: '2023',
                                    pohonable_type: 'Strategi', pohonable_id: strategi.id, role: 'strategi_pohon_kota')
    tactical = create(:strategi,
                      type: 'StrategiPohon',
                      strategi: 'test tactical',
                      opd_id: user.opd.id,
                      tahun: '2023',
                      nip_asn: '',
                      role: 'eselon_3',
                      strategi_ref_id: '')
    sasaran = create(:sasaran, user: nil, strategi_id: tactical.id, id_rencana: 'xx2', tahun: '2023')
    create(:indikator_sasaran, indikator_kinerja: 'test ind',
                               target: '100', satuan: '%',
                               sasaran_id: sasaran.id_rencana)
    create(:pohon, keterangan: 'test tactical pohon', opd_id: user.opd.id, tahun: '2023',
                   pohonable_type: 'Strategi', pohonable_id: tactical.id, role: 'tactical_pohon_kota', pohon_ref_id: pohon_strategi.id)
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

    expect(page).to have_content("Strategic")
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

  context "setujui pohon kota", :js do
    before(:each) do
      strategi_pohon_test
      visit manual_pohon_kinerja_index_path

      expect(page).to have_content('Strategic - Kota')
      expect(page).to have_content('test pohon 1')

      click_on "Terima"
      click_button "Ya"
    end

    scenario "success" do
      # sweetalert
      click_button "Ok"

      expect(page).to have_css(".pohon-accepted")
    end

    scenario "gagal" do
      raise "i don't know how to make this failed from spec"

      expect(page).to have_content("Terjadi kesalahan")
    end
  end

  context "tolak pohon kota", :js do
    before(:each) do
      strategi_pohon_test
      visit manual_pohon_kinerja_index_path

      expect(page).to have_content('Strategic - Kota')
      expect(page).to have_content('test pohon 1')
    end

    scenario "success" do
      click_on "Tolak"

      within("#form-modal-body") do
        fill_in "pohon[keterangan_tolak]", with: "keterangan ditolak"
        click_on "Tolak"
      end

      # click_button "Ya"
      # sweetalert
      click_button "Ok"

      expect(page).to have_css(".pohon-rejected")
    end
  end

  context "tactical", :js do
    before(:each) do
      tactical_test
      visit manual_pohon_kinerja_index_path
    end

    scenario "muncul dibawah strategic" do
      click_on "Tampilkan"

      expect(page).to have_css(".tactical-pohon")
      expect(page).to have_content("test tactical")
    end

    scenario "add new" do
      click_on "Tampilkan"

      click_on "Tactical"

      within('.strategi_pohon') do
        within('.pohon-body') do
          fill_in "Strategi", with: "contoh tactical"
          fill_in "Sasaran", with: "contoh sasaran"
          fill_in "Indikator kinerja", with: "Indikator strategi"
          fill_in "Target", with: "100"
          fill_in "Satuan", with: "%"
          click_on "Simpan Strategi pohon"
        end
      end

      # sweetalert
      click_button "Ok"

      expect(page).to have_content("contoh tactical")
      expect(page).to have_css(".strategic-pohon")
    end
  end

  context "tactical pohon", :js do
    before(:each) do
      tactical_pohon_test
      visit manual_pohon_kinerja_index_path
    end

    scenario "muncul dibawah strategic" do
      within(".strategi-pohon-kota") do
        click_on "Tampilkan"
      end

      expect(page).to have_css(".tactical-pohon")
      expect(page).to have_content("Tactical - Kota")
      expect(page).to have_content("test tactical")
    end

    scenario "add new" do
      within(".strategi-pohon-kota") do
        click_on "Tampilkan"
      end

      click_on "Tactical - Kota"

      within('.tactical-tematik') do
        within('.pohon-body') do
          fill_in "strategi_strategi", with: "contoh tactical"
          fill_in "Sasaran", with: "contoh sasaran"
          fill_in "Indikator kinerja", with: "Indikator strategi"
          fill_in "Target", with: "100"
          fill_in "Satuan", with: "%"
          fill_in "Keterangan", with: "contoh keterangan"
          click_on "Simpan"
        end
      end

      # sweetalert
      click_button "Ok"

      expect(page).to have_content("contoh tactical")
      expect(page).to have_css(".tactical-tematik")
    end
  end

  def operational_test
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
    tactical = create(:strategi,
                      type: 'StrategiPohon',
                      strategi: 'test tactical',
                      opd_id: user.opd.id,
                      tahun: '2023',
                      nip_asn: '',
                      role: 'eselon_3',
                      strategi_ref_id: strategi.id)
    sasaran_tactical = create(:sasaran, user: nil, strategi_id: tactical.id, id_rencana: 'xx2', tahun: '2023')
    create(:indikator_sasaran, indikator_kinerja: 'test ind',
                               target: '100', satuan: '%',
                               sasaran_id: sasaran_tactical.id_rencana)
    operational = create(:strategi,
                         type: 'StrategiPohon',
                         strategi: 'test operational',
                         opd_id: user.opd.id,
                         tahun: '2023',
                         nip_asn: '',
                         role: 'eselon_4',
                         strategi_ref_id: tactical.id)
    sasaran_operational = create(:sasaran, user: nil, strategi_id: operational.id, id_rencana: 'xx3', tahun: '2023')
    create(:indikator_sasaran, indikator_kinerja: 'test ind',
                               target: '100', satuan: '%',
                               sasaran_id: sasaran_operational.id_rencana)
  end

  context "operational", :js do
    before(:each) do
      operational_test
      visit manual_pohon_kinerja_index_path
    end

    scenario "muncul dibawah tactical" do
      within(".strategic-pohon") do
        click_on "Tampilkan"
      end
      within('.tactical-pohon') do
        click_on "Tampilkan"
      end

      expect(page).to have_css(".operational-pohon")
      expect(page).to have_content("test operational")
    end

    scenario "add new" do
      within(".strategic-pohon") do
        click_on "Tampilkan"
      end
      within('.tactical-pohon') do
        click_on "Tampilkan"
      end

      click_on "Operational"

      expect(page).to have_content("Operational Baru")

      within('.strategi_pohon') do
        within('.pohon-body') do
          fill_in "Strategi", with: "contoh operational"
          fill_in "Sasaran", with: "contoh sasaran"
          fill_in "Indikator kinerja", with: "Indikator operational"
          fill_in "Target", with: "100"
          fill_in "Satuan", with: "%"
          click_on "Simpan Strategi pohon"
        end
      end

      # sweetalert
      click_button "Ok"

      expect(page).to have_content("contoh operational")
      expect(page).to have_css(".operational-pohon")
    end
  end

  def operational_pohon_test
    strategi = create(:strategi,
                      type: 'StrategiPohon',
                      strategi: 'test pohon 1',
                      opd_id: user.opd.id,
                      tahun: '2023',
                      nip_asn: '',
                      role: 'eselon_2')
    sasaran_strategi = create(:sasaran, user: nil, strategi_id: strategi.id, id_rencana: 'xx1', tahun: '2023')
    create(:indikator_sasaran, indikator_kinerja: 'test ind',
                               target: '100', satuan: '%',
                               sasaran_id: sasaran_strategi.id_rencana)
    pohon_strategi = create(:pohon, keterangan: 'test pohon', opd_id: user.opd.id, tahun: '2023',
                                    pohonable_type: 'Strategi', pohonable_id: strategi.id, role: 'strategi_pohon_kota')
    tactical = create(:strategi,
                      type: 'StrategiPohon',
                      strategi: 'test tactical',
                      opd_id: user.opd.id,
                      tahun: '2023',
                      nip_asn: '',
                      role: 'eselon_3',
                      strategi_ref_id: '')
    sasaran_tactical = create(:sasaran, user: nil, strategi_id: tactical.id, id_rencana: 'xx2', tahun: '2023')
    create(:indikator_sasaran, indikator_kinerja: 'test ind',
                               target: '100', satuan: '%',
                               sasaran_id: sasaran_tactical.id_rencana)
    pohon_tactical = create(:pohon, keterangan: 'test tactical pohon', opd_id: user.opd.id, tahun: '2023',
                                    pohonable_type: 'Strategi', pohonable_id: tactical.id, role: 'tactical_pohon_kota',
                                    pohon_ref_id: pohon_strategi.id)
    operational = create(:strategi,
                         type: 'StrategiPohon',
                         strategi: 'test operational',
                         opd_id: user.opd.id,
                         tahun: '2023',
                         nip_asn: '',
                         role: 'eselon_4',
                         strategi_ref_id: '')
    sasaran_operational = create(:sasaran, user: nil, strategi_id: operational.id, id_rencana: 'xx3', tahun: '2023')
    create(:indikator_sasaran, indikator_kinerja: 'test ind',
                               target: '100', satuan: '%',
                               sasaran_id: sasaran_operational.id_rencana)
    create(:pohon, keterangan: 'test operational pohon', opd_id: user.opd.id, tahun: '2023',
                   pohonable_type: 'Strategi', pohonable_id: operational.id, role: 'operational_pohon_kota',
                   pohon_ref_id: pohon_tactical.id)
  end

  context "operational pohon", :js do
    before(:each) do
      operational_pohon_test
      visit manual_pohon_kinerja_index_path
    end

    scenario "muncul dibawah tactical" do
      within(".strategi-pohon-kota") do
        click_on "Tampilkan"
      end
      within('.tactical-pohon-kota') do
        click_on "Tampilkan"
      end

      expect(page).to have_css(".operational-pohon")
      expect(page).to have_content("Operational - Kota")
      expect(page).to have_content("test operational")
    end

    scenario "add new" do
      within(".strategi-pohon-kota") do
        click_on "Tampilkan"
      end
      within('.tactical-pohon-kota') do
        click_on "Tampilkan"
      end

      click_on "Operational - Kota"

      expect(page).to have_content("Operational Tematik Baru")

      within('.operational-tematik') do
        within('.pohon-body') do
          fill_in "strategi_strategi", with: "contoh operational"
          fill_in "Sasaran", with: "contoh sasaran"
          fill_in "Indikator kinerja", with: "Indikator strategi"
          fill_in "Target", with: "100"
          fill_in "Satuan", with: "%"
          fill_in "Keterangan", with: "contoh keterangan"
          click_on "Simpan"
        end
      end

      # sweetalert
      click_button "Ok"

      expect(page).to have_content("Operational - Kota")
      expect(page).to have_content("contoh operational")
      expect(page).to have_css(".operational-tematik")
    end
  end
end
