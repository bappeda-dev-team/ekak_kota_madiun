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
#  user_id             :bigint           not null
#
# Indexes
#
#  index_kaks_on_program_kegiatan_id  (program_kegiatan_id)
#  index_kaks_on_user_id              (user_id)
#
require 'rails_helper'

RSpec.describe Kak, type: :model do
  it "bisa dibuat tanpa program kegiatan" do
    expect(Kak.new.program_kegiatan).to be_nil 
  end

  it { is_expected.to belong_to(:user) }
  
  
end
