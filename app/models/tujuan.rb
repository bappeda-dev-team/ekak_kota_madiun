# == Schema Information
#
# Table name: tujuans
#
#  id               :bigint           not null, primary key
#  id_tujuan        :string           not null
#  kode_unik_opd    :string
#  tahun_akhir      :string
#  tahun_awal       :string
#  tujuan           :string
#  type             :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  bidang_urusan_id :bigint
#  urusan_id        :bigint
#
class Tujuan < ApplicationRecord
end
