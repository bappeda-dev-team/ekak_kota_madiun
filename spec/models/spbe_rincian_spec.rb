# == Schema Information
#
# Table name: spbe_rincians
#
#  id                     :bigint           not null, primary key
#  detail_kebutuhan       :string
#  detail_sasaran_kinerja :string
#  domain_spbe            :string
#  id_rencana             :string
#  internal_external      :string
#  kebutuhan_spbe         :string
#  keterangan             :string
#  kode_opd               :string
#  kode_program           :string
#  tahun_akhir            :string
#  tahun_awal             :string
#  tahun_pelaksanaan      :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  spbe_id                :bigint
#  strategi_ref_id        :string
#
require 'rails_helper'

RSpec.describe SpbeRincian, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
