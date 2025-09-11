# == Schema Information
#
# Table name: tte_documents
#
#  id            :bigint           not null, primary key
#  doc_url       :string
#  error_message :string
#  kode_opd      :string
#  status        :string           default("diproses")
#  tahun         :string           not null
#  tte_doc_url   :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  user_id       :bigint           not null
#
# Indexes
#
#  index_tte_documents_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe TteDocument, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
