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
require 'rails_helper'

RSpec.describe Search::AllUsulan, type: :model do
  context 'validation' do
    it { is_expected.to belong_to(:searchable) }
  end
end
