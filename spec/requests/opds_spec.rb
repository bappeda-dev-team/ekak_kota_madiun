require 'rails_helper'

RSpec.describe "Opds", type: :request do
  # get request -> index, show
    it 'can access index page' do
      get "/opds"
      expect(response).to render_template(:index)
    end
    it 'can access show page by id' do
      opd = Opd.create(nama_opd: "Dinas Pendidikan", kode_opd: "0001")
      get "/opd/#{opd.id}"
      expect(response).to render_template(:show)
    end
    
  
  # post request -> new, update, delete

  # check the response body and status -> success, 
  # expect(response.body).to include 'the message or something we create'
  # expect(response).to have_http_status(200)
end
