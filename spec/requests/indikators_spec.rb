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

RSpec.describe "/indikators", type: :request do
  
  # This should return the minimal set of attributes required to create a valid
  # Indikator. As you add validations to Indikator, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  describe "GET /index" do
    it "renders a successful response" do
      Indikator.create! valid_attributes
      get indikators_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      indikator = Indikator.create! valid_attributes
      get indikator_url(indikator)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_indikator_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      indikator = Indikator.create! valid_attributes
      get edit_indikator_url(indikator)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Indikator" do
        expect {
          post indikators_url, params: { indikator: valid_attributes }
        }.to change(Indikator, :count).by(1)
      end

      it "redirects to the created indikator" do
        post indikators_url, params: { indikator: valid_attributes }
        expect(response).to redirect_to(indikator_url(Indikator.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Indikator" do
        expect {
          post indikators_url, params: { indikator: invalid_attributes }
        }.to change(Indikator, :count).by(0)
      end

    
      it "renders a successful response (i.e. to display the 'new' template)" do
        post indikators_url, params: { indikator: invalid_attributes }
        expect(response).to be_successful
      end
    
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested indikator" do
        indikator = Indikator.create! valid_attributes
        patch indikator_url(indikator), params: { indikator: new_attributes }
        indikator.reload
        skip("Add assertions for updated state")
      end

      it "redirects to the indikator" do
        indikator = Indikator.create! valid_attributes
        patch indikator_url(indikator), params: { indikator: new_attributes }
        indikator.reload
        expect(response).to redirect_to(indikator_url(indikator))
      end
    end

    context "with invalid parameters" do
    
      it "renders a successful response (i.e. to display the 'edit' template)" do
        indikator = Indikator.create! valid_attributes
        patch indikator_url(indikator), params: { indikator: invalid_attributes }
        expect(response).to be_successful
      end
    
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested indikator" do
      indikator = Indikator.create! valid_attributes
      expect {
        delete indikator_url(indikator)
      }.to change(Indikator, :count).by(-1)
    end

    it "redirects to the indikators list" do
      indikator = Indikator.create! valid_attributes
      delete indikator_url(indikator)
      expect(response).to redirect_to(indikators_url)
    end
  end
end