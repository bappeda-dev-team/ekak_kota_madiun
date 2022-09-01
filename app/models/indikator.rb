# == Schema Information
#
# Table name: indikators
#
#  id        :bigint           not null, primary key
#  indikator :string
#  jenis     :string
#  kode      :string
#  satuan    :string
#  sub_jenis :string
#  tahun     :string
#  target    :string
#
class Indikator < ApplicationRecord
end
