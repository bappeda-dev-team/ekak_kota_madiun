# == Schema Information
#
# Table name: kaks
#
#  id                  :bigint           not null, primary key
#  biaya_diperlukan    :text
#  dasar_hukum         :text             default([]), is an Array
#  gambaran_umum       :text
#  metode_pelaksanaan  :text
#  penerima_manfaat    :text
#  tahapan_pelaksanaan :text
#  waktu_dibutuhkan    :text
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  program_kegiatan_id :bigint
#
# Indexes
#
#  index_kaks_on_program_kegiatan_id  (program_kegiatan_id)
#
require 'rails_helper'

RSpec.describe Kak, type: :model do
  context 'validation' do
    it { should validate_presence_of(:dasar_hukum) }
  end
  context 'association' do
    it { should belong_to(:program_kegiatan).optional }
  end
end
