# == Schema Information
#
# Table name: permasalahan_opds
#
#  id                         :bigint           not null, primary key
#  faktor_penghambat_skp      :string
#  jenis                      :string
#  kode_opd                   :string
#  kode_permasalahan_external :string
#  permasalahan               :string
#  status                     :string
#  tahun                      :string
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  isu_strategis_opd_id       :bigint
#
# Indexes
#
#  index_permasalahan_opds_on_isu_strategis_opd_id  (isu_strategis_opd_id)
#
require 'rails_helper'

RSpec.describe PermasalahanOpd, type: :model do
  it { should belong_to :isu_strategis_opd }
  it { should belong_to(:opd).optional }

  it 'can add data dukung' do
    opd_test = create(:opd)
    isu_strategis = create(:isu_strategis_opd,
                           kode_opd: opd_test.kode_unik_opd)
    prm_opd = create(:permasalahan_opd,
                     tahun: '2024',
                     isu_strategis_opd: isu_strategis,
                     kode_opd: opd_test.kode_unik_opd)
    data_dkng = prm_opd.data_dukungs.create([{ nama_data: 'test',
                                               keterangan: 'abs' },
                                             { nama_data: 'test 2',
                                               keterangan: 'abs' }])

    expect(prm_opd.data_dukungs).to eq(data_dkng)
  end
end
