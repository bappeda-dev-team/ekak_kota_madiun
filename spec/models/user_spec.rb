# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  eselon                 :string
#  id_bidang              :bigint
#  jabatan                :string
#  kode_opd               :string
#  nama                   :string
#  nama_bidang            :string
#  nama_pangkat           :string
#  nik                    :string
#  pangkat                :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_nik                   (nik) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:nama) }
    it { should validate_presence_of(:nik) }
    it { should validate_presence_of(:password) }
  end

  context 'having sasarans that varying between four state, red, green, yellow, blue' do
    before(:each) do
      @user = FactoryBot.create(:user)
      @mandatori = FactoryBot.create(:mandatori)
      @program_kegiatan = FactoryBot.create(:program_kegiatan)
      @tematik = FactoryBot.create(:subkegiatan_tematik)
    end

    def sasarans
      10.times do |i|
        @user.sasarans.create!(sasaran_kinerja: "Sasaran Kinerja #{i}", nip_asn: @user)
      end
    end
    it 'should count as red at the begining' do
      sasarans
      expect(@user.sasarans.count).to eq(10)
      petunjuk = @user.petunjuk_sasaran
      expect(petunjuk[:merah]).to eq(10)
    end

    it 'should change to yellow after added usulan' do
      sasarans
      sasaran = @user.sasarans.first
      Usulan.create!(usulanable_id: @mandatori.id, usulanable_type: @mandatori.class.name.to_s, sasaran_id: sasaran.id)
      expect(sasaran.usulans.count).to eq(1)
      expect(sasaran.status_sasaran).to eq('blm_lengkap')
      petunjuk = @user.petunjuk_sasaran
      expect(petunjuk[:merah]).to eq(9)
      expect(petunjuk[:kuning]).to eq(1)
    end

    it 'should change to blue after added program' do
      sasarans
      sasaran = @user.sasarans.first
      Usulan.create!(usulanable_id: @mandatori.id, usulanable_type: @mandatori.class.name, sasaran_id: sasaran.id)
      expect(sasaran.usulans.count).to eq(1)
      expect(sasaran.status_sasaran).to eq('blm_lengkap')
      sasaran.update!(program_kegiatan: @program_kegiatan)
      expect(sasaran.program_kegiatan.nil?).to eq(false)
      expect(sasaran.status_sasaran).to eq('krg_lengkap')
      petunjuk = @user.petunjuk_sasaran
      expect(petunjuk[:merah]).to eq(9)
      expect(petunjuk[:kuning]).to eq(0)
      expect(petunjuk[:biru]).to eq(1)
      expect(petunjuk[:hijau]).to eq(0)
    end

    it 'should change to green after full input' do
      sasarans
      sasaran = @user.sasarans.first
      Usulan.create!(usulanable_id: @mandatori.id, usulanable_type: @mandatori.class.name, sasaran_id: sasaran.id)
      expect(sasaran.usulans.count).to eq(1)
      expect(sasaran.status_sasaran).to eq('blm_lengkap')
      sasaran.update!(program_kegiatan: @program_kegiatan)
      expect(sasaran.program_kegiatan.nil?).to eq(false)
      expect(sasaran.status_sasaran).to eq('krg_lengkap')
      sasaran.dasar_hukums.create!(judul: 'dasar hukum', peraturan: 'test peraturan')
      expect(sasaran.dasar_hukums.exists?).to eq(true)
      sasaran.create_rincian!(data_terpilah: 'Test data', lokasi_pelaksanaan: 'Kota Madiun', resiko: 'SOmething')
      expect(sasaran.rincian.present?).to eq(true)
      sasaran.update!(penerima_manfaat: 'Test penerima manfaat')
      expect(sasaran.rincian?).to eq(true)
      sasaran.latar_belakangs.create!(gambaran_umum: 'Tanggung jawab asn adalah ya bekerja')
      sasaran.permasalahans.create!(jenis: 'umum', penyebab_external: 'external', penyebab_internal: 'internal')
      sasaran.add_tematik(sasaran: sasaran.id, tematik: @tematik.id)
      petunjuk = @user.petunjuk_sasaran
      expect(petunjuk[:merah]).to eq(9)
      expect(petunjuk[:kuning]).to eq(0)
      expect(petunjuk[:biru]).to eq(0)
      expect(petunjuk[:hijau]).to eq(1)
    end
  end
end
