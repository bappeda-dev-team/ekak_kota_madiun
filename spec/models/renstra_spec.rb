# == Schema Information
#
# Table name: renstras
#
#  id                     :bigint           not null, primary key
#  id_bidang_urusan       :string
#  id_giat_sipd           :string
#  id_program_sipd        :string
#  id_renstra             :string
#  id_rpjmd_sipd          :string
#  id_skpd                :string
#  id_sub_giat_sipd       :string
#  id_unit                :string
#  indikator_kegiatan     :string
#  indikator_program      :string
#  indikator_sub_giat     :string
#  kode_bidang_urusan     :string
#  kode_giat              :string
#  kode_program           :string
#  kode_skpd              :string
#  kode_sub_giat          :string
#  misi                   :string
#  nama_bidang_urusan     :string
#  nama_giat              :string
#  nama_program           :string
#  nama_skpd              :string
#  nama_sub_giat          :string
#  pagu_giat_1            :string
#  pagu_giat_2            :string
#  pagu_giat_3            :string
#  pagu_giat_4            :string
#  pagu_giat_5            :string
#  pagu_sub_giat_1        :string
#  pagu_sub_giat_2        :string
#  pagu_sub_giat_3        :string
#  pagu_sub_giat_4        :string
#  pagu_sub_giat_5        :string
#  sasaran                :string
#  satuan_target_giat     :string
#  satuan_target_sub_giat :string
#  strategi               :string
#  target_giat_1          :string
#  target_giat_2          :string
#  target_giat_3          :string
#  target_giat_4          :string
#  target_giat_5          :string
#  target_sub_giat_1      :string
#  target_sub_giat_2      :string
#  target_sub_giat_3      :string
#  target_sub_giat_4      :string
#  target_sub_giat_5      :string
#  tujuan                 :string
#  visi                   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_renstras_on_id_renstra  (id_renstra) UNIQUE
#
require 'rails_helper'

RSpec.describe Renstra, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
