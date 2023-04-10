# == Schema Information
#
# Table name: pagu_anggarans
#
#  id               :bigint           not null, primary key
#  anggaran         :decimal(, )
#  jenis            :string
#  keterangan       :string
#  kode             :string
#  kode_belanja     :string
#  kode_opd         :string
#  kode_sub_belanja :string
#  sub_jenis        :string
#  tahun            :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
class PaguAnggaran < ApplicationRecord
  # kode -> kode_sub_kegiatan
  # kode_belanja -> kode_parent_belanja
  # kode_sub_bealanja -> kode_rek_belanja
end
