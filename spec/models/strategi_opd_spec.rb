# == Schema Information
#
# Table name: strategi_opds
#
#  id                   :bigint           not null, primary key
#  keterangan           :string
#  strategi             :string
#  tahun                :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  isu_strategis_opd_id :string
#  opd_id               :string
#  sasaran_opd_id       :string
#
require 'rails_helper'

RSpec.describe StrategiOpd, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
