# == Schema Information
#
# Table name: genders
#
#  id                  :bigint           not null, primary key
#  akses               :string
#  data_terpilah       :string
#  indikator           :string
#  kontrol             :string
#  manfaat             :string
#  partisipasi         :string
#  penerima_manfaat    :string
#  penyebab_external   :string
#  penyebab_internal   :string
#  reformulasi_tujuan  :string
#  sasaran_subkegiatan :string
#  satuan              :string
#  target              :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  program_kegiatan_id :bigint
#  sasaran_id          :bigint
#
# Indexes
#
#  index_genders_on_program_kegiatan_id  (program_kegiatan_id)
#  index_genders_on_sasaran_id           (sasaran_id)
#
require 'rails_helper'

RSpec.describe Gender, type: :model do
  it { should validate_presence_of :akses }
  it { should validate_presence_of :partisipasi }
  it { should validate_presence_of :kontrol }
  it { should validate_presence_of :manfaat }
  it { should validate_presence_of :sasaran_subkegiatan }
  it { should validate_presence_of :reformulasi_tujuan }
  it { should validate_presence_of :penerima_manfaat }
end
