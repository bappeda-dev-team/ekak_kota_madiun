require 'rails_helper'

RSpec.describe "CRUD Sasaran", type: :system do
  before do
    visit user_sasarans_path
  end

  scenario 'index page' do
    expect(page).to have_content('Sasaran')
  end
end
