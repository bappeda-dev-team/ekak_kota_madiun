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
#  pagu           :string           default("0")
#  satuan         :string
#  sub_jenis      :string
#  tahun          :string
#  target         :string
#  version        :integer          default(0), not null
#
class Indikator < ApplicationRecord
end
