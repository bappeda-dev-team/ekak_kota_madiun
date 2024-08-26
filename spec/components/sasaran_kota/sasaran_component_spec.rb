# frozen_string_literal: true

require 'rails_helper'
# TODO: Extract helper method
RSpec.describe SasaranKota::SasaranComponent, type: :component do
  let(:tahun) { '2024' }
  let(:opd) { FactoryBot.create :opd, nama_opd: 'Test OPD' }
  let(:tematik) { FactoryBot.create(:tematik, tahun: tahun) }
  let(:sub_tematik) { FactoryBot.create(:sub_tematik, tematik: tematik, tahun: tahun) }
  let(:pohon_sub_tematik) do
    FactoryBot.create(:pohon, tahun: tahun,
                              role: 'sub_pohon_kota',
                              pohonable: sub_tematik)
  end

  it "renders renaksi" do
    strategic = FactoryBot.create(:strategi,
                                  strategi: 'Renaksi-A',
                                  tahun: tahun,
                                  opd: opd)
    pohon_strategic = FactoryBot.create(:pohon, tahun: tahun, role: 'strategi_pohon_kota',
                                                pohonable_type: strategic.class.name, pohonable: strategic,
                                                status: 'diterima',
                                                opd_id: opd.id)

    component = described_class.new(sasaran: pohon_strategic, tahun: tahun)

    render_inline(component)
    expect(page).to have_css "td.renaksi", text: 'Renaksi-A'
  end

  it 'renders jenis-renaksi' do
    strategic = FactoryBot.create(:strategi,
                                  strategi: 'Renaksi-A',
                                  tahun: tahun,
                                  opd: opd)
    pohon_strategic = FactoryBot.create(:pohon, tahun: tahun, role: 'strategi_pohon_kota',
                                                pohonable_type: strategic.class.name, pohonable: strategic,
                                                status: 'diterima',
                                                opd_id: opd.id)

    component = described_class.new(sasaran: pohon_strategic, tahun: tahun)

    render_inline(component)
    expect(page).to have_css "td.jenis-renaksi", text: 'Strategic'
  end

  it 'renders opd pelaksana' do
    strategic = FactoryBot.create(:strategi,
                                  strategi: 'Renaksi-A',
                                  tahun: tahun,
                                  opd: opd)
    pohon_strategic = FactoryBot.create(:pohon, tahun: tahun, role: 'strategi_pohon_kota',
                                                pohonable_type: strategic.class.name, pohonable: strategic,
                                                status: 'diterima',
                                                opd_id: opd.id)

    component = described_class.new(sasaran: pohon_strategic, tahun: tahun)

    render_inline(component)
    expect(page).to have_css "td.opd-pelaksana", text: 'Test OPD'
  end

  it 'renders nama-nip pelaksana with blank inovasi' do
    strategic = FactoryBot.create(:strategi,
                                  strategi: 'Renaksi-A',
                                  tahun: tahun,
                                  opd: opd)

    pohon_strategic = FactoryBot.create(:pohon, tahun: tahun, role: 'strategi_pohon_kota',
                                                pohonable_type: strategic.class.name, pohonable: strategic,
                                                status: 'diterima',
                                                opd_id: opd.id)

    pelaksana = FactoryBot.create(:eselon_2, opd: opd,
                                             nama: 'Kepala-OPD-X',
                                             nik: '123-456')
    FactoryBot.create(:sasaran, tahun: tahun,
                                user: pelaksana,
                                strategi_id: strategic.id)
    # puts 'User Strategic'
    # puts pohon_strategic.pohonable.sasarans.map(&:nama_pemilik)
    component = described_class.new(sasaran: pohon_strategic, tahun: tahun)

    render_inline(component)
    expect(page).to have_css "td.nama-pelaksana", text: 'Kepala-OPD-X'
    expect(page).to have_css "td.nip-pelaksana", text: '123-456'
    expect(page).to have_css "td.inovasi-pelaksana", text: ''
  end

  context 'pelaksana level subkegiatan' do
    it 'renders nama-nip-inovasi pelaksana' do
      strategic = FactoryBot.create(:strategi,
                                    strategi: 'Renaksi-A',
                                    tahun: tahun,
                                    opd: opd)

      pohon_strategic = FactoryBot.create(:pohon, tahun: tahun, role: 'strategi_pohon_kota',
                                                  pohonable_type: strategic.class.name,
                                                  pohonable: strategic,
                                                  status: 'diterima',
                                                  opd_id: opd.id)
      pelaksana = FactoryBot.create(:eselon_2, opd: opd,
                                               nama: 'Kepala-OPD-X',
                                               nik: '123-456')

      sasaran = FactoryBot.create(:sasaran, tahun: tahun,
                                            user: pelaksana,
                                            strategi_id: strategic.id)
      sasaran.update(metadata: {
                       hasil_inovasi: 'Inovasi',
                       inovasi_sasaran: 'Inovasi-Aplikasi-X',
                       gambaran_nilai_kebaruan: 'Kebaruan X',
                       processed_at: DateTime.current
                     })

      component = described_class.new(sasaran: pohon_strategic, tahun: tahun)
      render_inline(component)
      expect(page).to have_css "td.nama-pelaksana", text: 'Kepala-OPD-X'
      expect(page).to have_css "td.nip-pelaksana", text: '123-456'
      expect(page).to have_css "td.inovasi-pelaksana", text: sasaran.inovasi_sasaran
    end
  end
end
