require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to test the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator. If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails. There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.

RSpec.describe "/realisasis", type: :request do
  
  # This should return the minimal set of attributes required to create a valid
  # Realisasi. As you add validations to Realisasi, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  describe "GET /index" do
    it "renders a successful response" do
      Realisasi.create! valid_attributes
      get realisasis_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      realisasi = Realisasi.create! valid_attributes
      get realisasi_url(realisasi)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_realisasi_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      realisasi = Realisasi.create! valid_attributes
      get edit_realisasi_url(realisasi)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Realisasi" do
        expect {
          post realisasis_url, params: { realisasi: valid_attributes }
        }.to change(Realisasi, :count).by(1)
      end

      it "redirects to the created realisasi" do
        post realisasis_url, params: { realisasi: valid_attributes }
        expect(response).to redirect_to(realisasi_url(Realisasi.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Realisasi" do
        expect {
          post realisasis_url, params: { realisasi: invalid_attributes }
        }.to change(Realisasi, :count).by(0)
      end

    
      it "renders a successful response (i.e. to display the 'new' template)" do
        post realisasis_url, params: { realisasi: invalid_attributes }
        expect(response).to be_successful
      end
    
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested realisasi" do
        realisasi = Realisasi.create! valid_attributes
        patch realisasi_url(realisasi), params: { realisasi: new_attributes }
        realisasi.reload
        skip("Add assertions for updated state")
      end

      it "redirects to the realisasi" do
        realisasi = Realisasi.create! valid_attributes
        patch realisasi_url(realisasi), params: { realisasi: new_attributes }
        realisasi.reload
        expect(response).to redirect_to(realisasi_url(realisasi))
      end
    end

    context "with invalid parameters" do
    
      it "renders a successful response (i.e. to display the 'edit' template)" do
        realisasi = Realisasi.create! valid_attributes
        patch realisasi_url(realisasi), params: { realisasi: invalid_attributes }
        expect(response).to be_successful
      end
    
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested realisasi" do
      realisasi = Realisasi.create! valid_attributes
      expect {
        delete realisasi_url(realisasi)
      }.to change(Realisasi, :count).by(-1)
    end

    it "redirects to the realisasis list" do
      realisasi = Realisasi.create! valid_attributes
      delete realisasi_url(realisasi)
      expect(response).to redirect_to(realisasis_url)
    end
  end
end
