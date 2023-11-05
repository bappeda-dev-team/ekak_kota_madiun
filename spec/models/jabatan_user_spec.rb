# == Schema Information
#
# Table name: jabatan_users
#
#  id         :bigint           not null, primary key
#  bulan      :string           not null
#  id_jabatan :bigint           not null
#  kode_opd   :string           not null
#  nip_asn    :string           not null
#  tahun      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe JabatanUser, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
