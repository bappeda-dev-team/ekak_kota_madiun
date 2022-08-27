# == Schema Information
#
# Table name: program_kegiatans
#
#  id                        :bigint           not null, primary key
#  id_giat                   :string
#  id_program_sipd           :string
#  id_sub_giat               :string
#  id_sub_unit               :string
#  id_unit                   :string
#  identifier_belanja        :string
#  indikator_kinerja         :string
#  indikator_program         :string
#  indikator_subkegiatan     :string
#  isu_strategis             :string
#  kode_bidang_urusan        :string
#  kode_giat                 :string
#  kode_opd                  :string
#  kode_program              :string
#  kode_skpd                 :string
#  kode_sub_giat             :string
#  kode_sub_skpd             :string
#  kode_urusan               :string
#  nama_bidang_urusan        :string
#  nama_kegiatan             :string
#  nama_program              :string
#  nama_subkegiatan          :string
#  nama_urusan               :string
#  pagu                      :string
#  satuan                    :string
#  satuan_target_program     :string
#  satuan_target_subkegiatan :string
#  tahun                     :string
#  target                    :string
#  target_program            :string
#  target_subkegiatan        :string
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  subkegiatan_tematik_id    :bigint
#
# Indexes
#
#  index_program_kegiatans_on_identifier_belanja      (identifier_belanja) UNIQUE
#  index_program_kegiatans_on_subkegiatan_tematik_id  (subkegiatan_tematik_id)
#
# Foreign Keys
#
#  fk_rails_...  (subkegiatan_tematik_id => subkegiatan_tematiks.id)
#
require 'rails_helper'

RSpec.describe ProgramKegiatan, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:nama_program) }
  end

  describe '#target_xx_tahun' do
    context 'target program tahun x' do
      it 'return target_program for tahun 2022' do
        program = create(:program_kegiatan, tahun: 2022, target_program: '100')
        prog = program.target_program_tahun(2022)
        expect(prog).to eq('100')
      end
      it 'return target_program for tahun 2024' do
        program = create(:program_kegiatan, tahun: 2024, target_program: '100')
        prog = program.target_program_tahun(2024)
        expect(prog).to eq('100')
      end
    end
    context 'target kegiatan tahun x' do
      it 'return target_kegiatan for tahun 2022' do
        kegiatan = create(:program_kegiatan, tahun: 2022, target: '200')
        expect(kegiatan.target_kegiatan_tahun(2022)).to eq('200')
      end
      it 'return target_kegiatan for tahun 2024' do
        kegiatan = create(:program_kegiatan, tahun: 2024, target: '400')
        expect(kegiatan.target_kegiatan_tahun(2024)).to eq('400')
      end
    end
    context 'target subkegiatan tahun x' do
      it 'return target_subkegiatan tahun 2022' do
        subkegiatan = create(:program_kegiatan, tahun: 2022, target_subkegiatan: '900')
        expect(subkegiatan.target_subkegiatan_tahun(2022)).to eq('900')
      end
      it 'return target_subkegiatan_tahun 2024' do
        subkegiatan = create(:program_kegiatan, tahun: 2024, target_subkegiatan: '500')
        expect(subkegiatan.target_subkegiatan_tahun(2024)).to eq('500')
      end
    end
  end

  describe '#pagu_program' do
    context 'show pagu program for tahun x' do
      it 'return pagu for tahun 2022' do
        program = create(:program_kegiatan, tahun: 2022)
        kegiatan = create(:program_kegiatan, tahun: 2022)
        sub_kegiatan_1 = create(:program_kegiatan, tahun: 2022, pagu: 5_000_000)
        sub_kegiatan_2 = create(:program_kegiatan, tahun: 2022, pagu: 5_000_000)
        pagu = program.pagu_program_tahun(2022)
        expect(pagu).to eq(10_000_000)
      end
    end
  end
end
