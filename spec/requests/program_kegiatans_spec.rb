require 'rails_helper'

RSpec.describe "ProgramKegiatans", type: :request do
  let(:user) { FactoryBot.create(:user) }

  describe "GET #index" do
    it 'show all subkegiatans' do
      sign_in(user)
      get "/program_kegiatans"
      # expect(response).to be_successful
      expect(response).to render_template(:index)
    end
  end
end
