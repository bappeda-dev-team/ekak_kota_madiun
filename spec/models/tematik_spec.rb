# == Schema Information
#
# Table name: tematiks
#
#  id             :bigint           not null, primary key
#  keterangan     :string
#  tema           :string
#  type           :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  tematik_ref_id :bigint
#
require 'rails_helper'

RSpec.describe Tematik, type: :model do
  it { should have_many(:indikators) }

  context "save indikator" do
    it "should save indikaor with jenis Tematik and sub_jenis Tematik" do
      tematik = Tematik.create(tema: 'Contoh', keterangan: 'Contoh Keterangan')
      indikator = Indikator.create(indikator: 'Indikator Contoh',
                                   jenis: 'Tematik',
                                   sub_jenis: 'Tematik',
                                   target: '100',
                                   satuan: '%',
                                   tahun: '2023',
                                   kode: tematik.id)
      expect(tematik.indikators).to include(indikator)
    end
  end
end
