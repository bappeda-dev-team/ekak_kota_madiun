# == Schema Information
#
# Table name: sasaran_opds
#
#  id            :bigint           not null, primary key
#  id_sasaran    :string
#  id_tujuan     :string
#  kode_unik_opd :string           not null
#  sasaran       :string           not null
#  tahun_akhir   :string
#  tahun_awal    :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
require 'rails_helper'

RSpec.describe SasaranOpd, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
