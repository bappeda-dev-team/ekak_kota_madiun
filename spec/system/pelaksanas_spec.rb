require 'rails_helper'

RSpec.describe "Pelaksanas", type: :system do
  let(:user) { create(:super_admin) }
  let(:periode) { create(:periode, tahun_awal: '2025', tahun_akhir: '2026') }

  def strategi(strategi_ref_id: '', **args)
    create(:strategi,
           type: 'StrategiPohon',
           strategi: 'test-1',
           opd_id: user.opd.id,
           tahun: '2025',
           nip_asn: '',
           strategi_ref_id: strategi_ref_id,
           role: '',
           **args)
  end

  def indikator(jenis: '', kode: '', indikator: 'indikator-test')
    create(:indikator, indikator: indikator,
                       target: '10', satuan: '%', tahun: '2025',
                       jenis: jenis, kode: kode)
  end
  context "pindah pelaksana pohon kinerja opd" do
    before(:each) do
      login_as user
      periode
      # setup cookies
      visit root_path

      create_cookie('opd', 'test_opd')
      create_cookie('tahun', '2025')
    end

    it 'should add pelaksana name', js: true do
      opd_id = user.opd.id
      strategic = strategi(strategi: 'strategi-1', opd_id: opd_id, role: 'eselon_2')
      eselon_2 = create(:eselon_2, nama: 'kepala-opd', email: 'contoh-email@email.com', nik: '123')

      visit cascading_pohon_kinerja_opds_path

      expect(page).to have_text('strategi-1')

      within("#strategi_pohon_#{strategic.id}") do
        click_on "Pelaksana"
      end

      expect(page).to have_text('Pelaksana')

      within("#form-pelaksana") do
        click_on "Edit"
      end

      expect(page).to have_text('Role')

      within("#form-pelaksana-body") do
        select2 'eselon_2', from: 'Role'
        select2_select eselon_2.nama, from: 'Asn'
        fill_in 'Keterangan', with: 'keterangan a'
        click_on 'Simpan perubahan'
      end

      click_on "Ok"

      expect(page).to have_text(eselon_2.nama)
    end
  end
end
