# == Schema Information
#
# Table name: spbes
#
#  id                  :bigint           not null, primary key
#  jenis_pelayanan     :string
#  kode_opd            :string
#  kode_program        :string
#  nama_aplikasi       :string
#  output_aplikasi     :string
#  output_cetak        :string
#  output_data         :string
#  output_informasi    :string
#  pemilik_aplikasi    :string
#  terintegrasi_dengan :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  program_kegiatan_id :bigint
#  strategi_id         :bigint
#  strategi_ref_id     :string
#
FactoryBot.define do
  factory :spbe do
    strategi_ref_id { 'test' }
    association :sasaran, factory: :sasaran, sasaran_kinerja: 'Test sasaran'
    association :opd
    association :program_kegiatan, nama_program: 'Test program'
    jenis_pelayanan { "Test Pelayanan" }
    nama_aplikasi { "Test nama aplikasi" }
  end
end
