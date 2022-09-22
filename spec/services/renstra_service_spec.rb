require 'rails_helper'

RSpec.describe RenstraService, type: :model do
  let(:kode_opd) { '5.01.5.05.0.00.02.0000' }
  let(:renstra) { RenstraService.new(kode_unik_opd: kode_opd, tahun: 2022) }
  let(:program_kegiatan_mock) { setup_opd_with_programs }
  let(:indikator) { FactoryBot.create(:indikator, tahun: '2022', jenis: 'Renstra', sub_jenis: 'Program', indikator: 'indikator_test', kode: '5.01.01') }

  def setup_opd_with_programs(*_args)
    opd = FactoryBot.create(:opd, kode_unik_opd: kode_opd)
    5.times { FactoryBot.create(:program_kegiatan, opd: opd, kode_program: '5.01.01') }
    FactoryBot.create(:indikator, tahun: '2022', jenis: 'Renstra', sub_jenis: 'Program', indikator: 'indikator_test', kode: '5.01.01')
  end

  context 'initialize class' do
    it 'should initialized by kode_unik_opd and tahun' do
      expect(renstra).to be_a(RenstraService)
    end
    it 'have kode_unik_opd and tahun attributes' do
      expect(renstra).to have_attributes(kode_unik_opd: kode_opd, tahun: 2022)
    end
    it 'find Opd by kode_unik_opd' do
      program_kegiatan_mock
      expect(renstra.opd).to be_a(Opd)
    end
    it 'have program_kegiatans by opd' do
      program_kegiatan_mock
      expect(renstra.program_kegiatan_opd).to be_exists
      expect(renstra.program_kegiatan_opd.size).to eq(5)
    end
    it 'separate programs from program_kegiatan' do
      program_kegiatan_mock
      expect(renstra.program_opd).to_not be_nil
    end
    it 'find program by kode_program' do
      program_kegiatan_mock
      renstra = RenstraService.new(kode_unik_opd: kode_opd, tahun: 2022, kode_program: '5.01.01')
      expect(renstra.program_kegiatan).to be_a(ProgramKegiatan)
    end
  end

  context 'indikator program renstra' do
    it 'returning program with indikator' do
      program_kegiatan_mock
      renstra = RenstraService.new(kode_unik_opd: kode_opd, tahun: 2022, kode_program: '5.01.01')
      expect(renstra.indikator_program).to include(indikator)
    end
  end
end
