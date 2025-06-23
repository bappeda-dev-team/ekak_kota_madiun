# == Schema Information
#
# Table name: bpmn_spbes
#
#  id         :bigint           not null, primary key
#  keterangan :string
#  kode_opd   :string
#  nama_bpmn  :string
#  tahun      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe BpmnSpbe, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
