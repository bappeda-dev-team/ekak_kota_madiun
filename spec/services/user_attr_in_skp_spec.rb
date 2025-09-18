require 'rails_helper'

RSpec.describe UserAttrInSkp, type: :model do
  let(:user) { create(:super_admin, opd: create(:opd, kode_unik_opd: '2.16.2.20.2.21.04.000')) }
  let(:tahun) { 2025 }
  subject { described_class.new(tahun: tahun, user: user) }

  describe '#initialize' do
    it 'initialize with user model and tahun' do
      epxect(subject.tahun).eq tahun
      expect(subject.user).eq user
    end
  end
end
