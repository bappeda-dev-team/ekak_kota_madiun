# == Schema Information
#
# Table name: master_bidang_urusans
#
#  id                    :bigint           not null, primary key
#  id_bidang_urusan_sipd :string
#  id_unik_sipd          :string           not null
#  id_urusan             :string
#  kode_bidang_urusan    :string
#  nama_bidang_urusan    :string
#  tahun                 :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
# Indexes
#
#  index_master_bidang_urusans_on_id_unik_sipd  (id_unik_sipd) UNIQUE
#
require 'rails_helper'

RSpec.describe Master::BidangUrusan, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
