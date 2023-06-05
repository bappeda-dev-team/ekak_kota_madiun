# == Schema Information
#
# Table name: spbe_rincians
#
#  id                     :bigint           not null, primary key
#  detail_kebutuhan       :string
#  detail_sasaran_kinerja :string
#  id_rencana             :string
#  kebutuhan_spbe         :string
#  keterangan             :string
#  kode_opd               :string
#  kode_program           :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  spbe_id                :bigint
#  strategi_ref_id        :string
#
class SpbeRincian < ApplicationRecord
  belongs_to :spbe

  belongs_to :sasaran, primary_key: :id, foreign_key: :id_rencana
end
