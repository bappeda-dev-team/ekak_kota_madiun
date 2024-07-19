# frozen_string_literal: true

require "rails_helper"

RSpec.describe TabelRenstraComponent, type: :component do
  context 'get each tahun in periode' do
    it 'should include all tahun' do
      generate_tabel_renstra_component do |component|
        periode = component.periode
        expect(periode).to include('2020', '2024', '2025')
      end
    end

    it 'should renders tahun by periode' do
      generate_tabel_renstra_component do |component|
        render_inline(component)
        tahun_in_periode = %w[2020 2021 2022 2023 2024 2025]
        all_tahun = all('th.tahun').map(&:text)
        expect(all_tahun).to match_array(tahun_in_periode)
      end
    end
  end

  describe 'basic renstra component' do
    # see program_kegiatans factory
    context 'urusan opd' do
      it 'should render nama and kode urusan' do
        generate_tabel_renstra_component do |component|
          render_inline(component)
          expect(page).to have_css 'td.kode-urusan', text: '5'
          expect(page).to have_css 'td.nama-urusan', text: 'UNSUR PENUNJANG URUSAN PEMERINTAHAN'
        end
      end
    end

    context 'bidang urusan opd' do
      it 'should render nama and kode bidang-urusan' do
        generate_tabel_renstra_component do |component|
          render_inline(component)
          expect(page).to have_css 'td.kode-bidang_urusan', text: '5.01'
          expect(page).to have_css 'td.nama-bidang_urusan', text: 'PERENCANAAN'
        end
      end
    end

    context 'program opd' do
      it 'should render nama and kode program' do
        generate_tabel_renstra_component do |component|
          render_inline(component)
          expect(page).to have_css 'td.kode-program', text: '5.01.01'
          expect(page).to have_css 'td.nama-program', text: 'PROGRAM PERENCANAAN, PENGENDALIAN DAN EVALUASI PEMBANGUNAN DAERAH'
        end
      end
    end

    context 'kegiatan opd' do
      it 'should render nama and kode kegiatan' do
        generate_tabel_renstra_component do |component|
          render_inline(component)
          expect(page).to have_css 'td.kode-kegiatan', text: '5.01.01.2.08'
          expect(page).to have_css 'td.nama-kegiatan', text: 'Penyusunan Perencanaan dan Pendanaan'
        end
      end
    end

    context 'subkegiatan opd' do
      it 'should render nama and kode subkegiatan' do
        generate_tabel_renstra_component do |component|
          render_inline(component)
          # kode di tweak ke XXXX (4 digit)
          expect(page).to have_css 'td.kode-subkegiatan', text: '5.01.01.2.08.0003'
          expect(page).to have_css 'td.nama-subkegiatan', text: 'Pelaksanaan Musrenbang Kabupaten/Kota'
        end
      end
    end
  end

  def renstra(tahun_awal:, tahun_akhir:)
    opd = FactoryBot.create(:opd,
                            nama_opd: 'Badan Perencanaan, Penelitian dan Pengembangan Daerah',
                            kode_unik_opd: '5.01.5.05.0.00.02.0000',
                            kode_opd: '5.01.5.05.0.00.02.0000')
    FactoryBot.create(:program_kegiatan, opd: opd)

    RenstraQueries.new(kode_opd: opd.kode_unik_opd, tahun_awal: tahun_awal, tahun_akhir: tahun_akhir)
  end

  def generate_tabel_renstra_component
    tahun_awal = '2020'
    tahun_akhir = '2025'

    setup = renstra(tahun_awal: tahun_awal, tahun_akhir: tahun_akhir)
    program_kegiatans = setup.program_kegiatan_renstra
    periode = setup.periode

    component = described_class.new(program_kegiatans: program_kegiatans,
                                    periode: periode,
                                    cetak: false)
    yield component
  end
end
