# == Schema Information
#
# Table name: indikators
#
#  id             :bigint           not null, primary key
#  indikator      :string
#  jenis          :string
#  keterangan     :string
#  kode           :string
#  kode_indikator :string
#  kode_opd       :string
#  kotak          :integer          default(0), not null
#  pagu           :string           default("0")
#  satuan         :string
#  sub_jenis      :string
#  tahun          :string
#  target         :string
#  version        :integer          default(0), not null
#
class Indikator < ApplicationRecord
  has_many :targets
  accepts_nested_attributes_for :targets, reject_if: :all_blank, allow_destroy: true

  def target_satuan
    "#{target} #{satuan}"
  end
end
