# frozen_string_literal: true

require "rails_helper"

RSpec.describe Sasaran::TahapanComponent, type: :component do
  pending "add some examples to (or delete) #{__FILE__}"

  it "renders tabel tahapan" do
    component = described_class.new(tahapan: "tahapan contoh")
    render_inline(component)

    expect(page).to have_content("tahapan contoh")
  end
end
