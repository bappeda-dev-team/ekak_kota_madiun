# == Schema Information
#
# Table name: latar_belakangs
#
#  id            :bigint           not null, primary key
#  dasar_hukum   :text
#  gambaran_umum :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
require 'rails_helper'

RSpec.describe LatarBelakang, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
