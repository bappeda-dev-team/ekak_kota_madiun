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

  describe 'ProgramKegiatan_program#target_renstra_program' do
    let(:program_kegiatan) { create(:program_kegiatan, kode_program: 'test_kode_program') }
    let!(:indikator_program_renstra) { create(:indikator, tahun: '2022', jenis: 'Renstra', sub_jenis: 'Program', indikator: 'indikator_test', kode: 'test_kode_program') }

    context "indikator by jenis Renstra and sub_jenis Program" do
      it 'should not empty' do
        expect(program_kegiatan.target_program_renstra).not_to be_empty
      end
      it 'should get indikator' do
        expect(program_kegiatan.target_program_renstra["2022"]).to have_key(:indikator)
      end
      it 'should get indikator' do
        expect(program_kegiatan.target_program_renstra["2022"]).to include(indikator: 'indikator_test')
      end
      it 'should return {indikator, pagu, satuan, target} by tahun' do
        expect(program_kegiatan.target_program_renstra).to include("2022" => { indikator: 'indikator_test', keterangan: nil, pagu: "0", satuan: 'MyString', target: 'MyString' })
      end
    end
  end
end
