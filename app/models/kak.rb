# == Schema Information
#
# Table name: kaks
#
#  id                  :bigint           not null, primary key
#  biaya_diperlukan    :text
#  dasar_hukum         :text             default([]), is an Array
#  gambaran_umum       :text
#  metode_pelaksanaan  :text
#  penerima_manfaat    :text
#  tahapan_pelaksanaan :text
#  waktu_dibutuhkan    :text
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  program_kegiatan_id :bigint
#
# Indexes
#
#  index_kaks_on_program_kegiatan_id  (program_kegiatan_id)
#
class Kak < ApplicationRecord
  belongs_to :program_kegiatan, optional: true
end
