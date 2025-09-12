# == Schema Information
#
# Table name: tte_documents
#
#  id            :bigint           not null, primary key
#  doc_url       :string
#  error_message :string
#  id_dokumen    :string
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
class TteDocument < ApplicationRecord
  belongs_to :user
  enum status: { diproses: "diproses", pending: "pending", signed: "signed", failed: "failed" }
  has_one_attached :doc_file
  has_one_attached :tte_doc_file
end
