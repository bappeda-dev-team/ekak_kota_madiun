# == Schema Information
#
# Table name: kaks
#
#  id                  :bigint           not null, primary key
#  dasar_hukum         :text             default([]), is an Array
#  tujuan              :text             default([]), is an Array
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  program_kegiatan_id :bigint
#  user_id             :bigint           not null
#
# Indexes
#
#  index_kaks_on_program_kegiatan_id  (program_kegiatan_id)
#  index_kaks_on_user_id              (user_id)
#
class Kak < ApplicationRecord
  belongs_to :program_kegiatan, optional: true
  belongs_to :user
end
