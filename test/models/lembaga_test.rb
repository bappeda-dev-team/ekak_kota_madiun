# == Schema Information
#
# Table name: lembagas
#
#  id           :bigint           not null, primary key
#  nama_lembaga :string
#  tahun        :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
require "test_helper"

class LembagaTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  setup do
    @lembaga = Lembaga.new(nama_lembaga: "Kota MAdiun", tahun: 17112021)
  end
  test "Lembaga punya Nama Lembaga" do
    @lembaga.nama_lembaga = nil
    assert @lembaga.valid?
  end
end
