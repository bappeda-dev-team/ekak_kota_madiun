# == Schema Information
#
# Table name: master_output_kegiatans
#
#  id                     :bigint           not null, primary key
#  id_bl                  :string
#  id_kegiatan            :string
#  id_output_bl           :string           not null
#  id_program             :string
#  id_skpd                :string
#  id_sub_kegiatan        :string
#  id_sub_skpd            :string
#  indikator_kegiatan     :string
#  indikator_sub_kegiatan :string
#  satuan_kegiatan        :string
#  satuan_sub_kegiatan    :string
#  tahun                  :string
#  target_kegiatan        :string
#  target_sub_kegiatan    :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_master_output_kegiatans_on_id_output_bl  (id_output_bl) UNIQUE
#
FactoryBot.define do
  factory :master_output_kegiatan, class: 'Master::OutputKegiatan' do
    
  end
end
