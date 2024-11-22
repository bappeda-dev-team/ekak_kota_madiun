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

RSpec.describe "/mitras", type: :request do
  
  # This should return the minimal set of attributes required to create a valid
  # Mitra. As you add validations to Mitra, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  describe "GET /index" do
    it "renders a successful response" do
      Mitra.create! valid_attributes
      get mitras_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      mitra = Mitra.create! valid_attributes
      get mitra_url(mitra)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_mitra_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      mitra = Mitra.create! valid_attributes
      get edit_mitra_url(mitra)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Mitra" do
        expect {
          post mitras_url, params: { mitra: valid_attributes }
        }.to change(Mitra, :count).by(1)
      end

      it "redirects to the created mitra" do
        post mitras_url, params: { mitra: valid_attributes }
        expect(response).to redirect_to(mitra_url(Mitra.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Mitra" do
        expect {
          post mitras_url, params: { mitra: invalid_attributes }
        }.to change(Mitra, :count).by(0)
      end

    
      it "renders a successful response (i.e. to display the 'new' template)" do
        post mitras_url, params: { mitra: invalid_attributes }
        expect(response).to be_successful
      end
    
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested mitra" do
        mitra = Mitra.create! valid_attributes
        patch mitra_url(mitra), params: { mitra: new_attributes }
        mitra.reload
        skip("Add assertions for updated state")
      end

      it "redirects to the mitra" do
        mitra = Mitra.create! valid_attributes
        patch mitra_url(mitra), params: { mitra: new_attributes }
        mitra.reload
        expect(response).to redirect_to(mitra_url(mitra))
      end
    end

    context "with invalid parameters" do
    
      it "renders a successful response (i.e. to display the 'edit' template)" do
        mitra = Mitra.create! valid_attributes
        patch mitra_url(mitra), params: { mitra: invalid_attributes }
        expect(response).to be_successful
      end
    
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested mitra" do
      mitra = Mitra.create! valid_attributes
      expect {
        delete mitra_url(mitra)
      }.to change(Mitra, :count).by(-1)
    end

    it "redirects to the mitras list" do
      mitra = Mitra.create! valid_attributes
      delete mitra_url(mitra)
      expect(response).to redirect_to(mitras_url)
    end
  end
end
