# == Schema Information
#
# Table name: permasalahan_opds
#
#  id                         :bigint           not null, primary key
#  faktor_penghambat_skp      :string
#  jenis                      :string
#  kode_opd                   :string
#  kode_permasalahan_external :string
#  permasalahan               :string
#  status                     :string
#  tahun                      :string
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  isu_strategis_opd_id       :bigint
#
# Indexes
#
#  index_permasalahan_opds_on_isu_strategis_opd_id  (isu_strategis_opd_id)
#
require 'rails_helper'

RSpec.describe PermasalahanOpd, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
