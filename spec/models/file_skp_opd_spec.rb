# == Schema Information
#
# Table name: file_skp_opds
#
#  id            :bigint           not null, primary key
#  kode_unik_opd :string
#  tahun         :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
require 'rails_helper'

RSpec.describe FileSkpOpd, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
