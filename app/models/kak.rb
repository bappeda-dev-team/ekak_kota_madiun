# == Schema Information
#
# Table name: kaks
#
#  id                  :bigint           not null, primary key
#  dasar_hukum         :text             default([]), is an Array
#  tujuan              :text             default([]), is an Array
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  user_id             :bigint           not null
#  program_kegiatan_id :bigint
#
class Kak < ApplicationRecord
  belongs_to :program_kegiatan, optional: true
  belongs_to :user
end
