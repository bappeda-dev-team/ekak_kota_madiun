require 'rails_helper'

RSpec.describe "ProgramKegiatans", type: :request do
  describe "GET Request" do
    it 'render index template' do
      get "/programKegiatans"
      expect(response).to render_template(:index)
    end
    it 'render new template' do
      get "/programKegiatan/new"
      expect(response).to render_template(:new)
    end
    it 'render show template' do
      programKegiatan = ProgramKegiatan.create(nama_program: "Program A", nama_kegiatan: "Kegiatan A", nama_subkegiatan: "Subkegiatan A", indikator_kinerja: "Indikator A", target: "Target A", satuan: "Satuan A")
      get "/programKegiatan/#{programKegiatan.id}"
      expect(response).to render_template(:show)
    end  
  end

  describe 'POST Request' do
    it 'can create new entry' do
      programKegiatan_params = { programKegiatan: {
        nama_program: "Program A",
        nama_kegiatan: "Kegiatan A", 
        nama_subkegiatan: "Subkegiatan A", 
        indikator_kinerja: "Indikator A", 
        target: "Target A", 
        satuan: "Satuan A"
      }}
      post "/programKegiatan", :params => programKegiatan_params
      expect(response).to have_http_status(302)
    end
  end
  

end
