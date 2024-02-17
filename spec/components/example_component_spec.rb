# frozen_string_literal: true

require "rails_helper"

RSpec.describe ExampleComponent, type: :component do
  it "renders something useful" do
    expect(
      render_inline(described_class.new(title: "Hello, components!")) { "Hello, components!" }.css("p").to_html
    ).to include(
      "Hello, components!"
    )
  end
end
