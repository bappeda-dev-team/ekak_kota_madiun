# == Schema Information
#
# Table name: master_programs
#
#  id               :bigint           not null, primary key
#  id_bidang_urusan :string
#  id_program_sipd  :string
#  id_unik_sipd     :string           not null
#  id_urusan        :string
#  kode_program     :string
#  nama_program     :string           default("-")
#  no_program       :string
#  tahun            :string           default("2022")
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_master_programs_on_id_unik_sipd  (id_unik_sipd) UNIQUE
#
FactoryBot.define do
  factory :master_program, class: 'Master::Program' do
    
  end
end
