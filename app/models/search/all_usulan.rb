# == Schema Information
#
# Table name: search_all_usulans
#
#  searchable_type :text
#  usulan          :text
#  sasaran_id      :bigint
#  searchable_id   :bigint
#
module Search
  class AllUsulan < ApplicationRecord
    belongs_to :searchable, polymorphic: true
  end
end
