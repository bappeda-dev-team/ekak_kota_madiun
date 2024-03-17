# == Schema Information
#
# Table name: search_all_usulans
#
#  nip_asn         :string
#  searchable_type :text
#  tahun           :string
#  usulan          :text
#  sasaran_id      :bigint
#  searchable_id   :bigint
#
module Search
  class AllUsulan < ApplicationRecord
    belongs_to :searchable, polymorphic: true
  end
end
