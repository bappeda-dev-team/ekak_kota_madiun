# == Schema Information
#
# Table name: kolabs
#
#  id             :bigint           not null, primary key
#  jenis          :string
#  keterangan     :string
#  kode_unik_opd  :string
#  kolabable_type :string
#  status         :string
#  tahun          :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  kolabable_id   :bigint
#
class Kolab < ApplicationRecord
  validates :kolabable_id, presence: true
  validates :kolabable_type, presence: true

  belongs_to :kolabable, polymorphic: true
  belongs_to :opd, foreign_key: "kode_unik_opd", primary_key: "kode_unik_opd", optional: true
end
