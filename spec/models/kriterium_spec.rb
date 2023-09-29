# == Schema Information
#
# Table name: kriteria
#
#  id            :bigint           not null, primary key
#  keterangan    :string
#  kriteria      :string
#  poin          :integer
#  poin_max      :integer
#  poin_min      :integer
#  tipe_kriteria :string
#  type          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  kriteria_id   :bigint
#
require 'rails_helper'

RSpec.describe Kriterium, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
