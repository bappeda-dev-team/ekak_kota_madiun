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

RSpec.describe "/subdomains", type: :request do
  
  # This should return the minimal set of attributes required to create a valid
  # Subdomain. As you add validations to Subdomain, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  describe "GET /index" do
    it "renders a successful response" do
      Subdomain.create! valid_attributes
      get subdomains_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      subdomain = Subdomain.create! valid_attributes
      get subdomain_url(subdomain)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_subdomain_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      subdomain = Subdomain.create! valid_attributes
      get edit_subdomain_url(subdomain)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Subdomain" do
        expect {
          post subdomains_url, params: { subdomain: valid_attributes }
        }.to change(Subdomain, :count).by(1)
      end

      it "redirects to the created subdomain" do
        post subdomains_url, params: { subdomain: valid_attributes }
        expect(response).to redirect_to(subdomain_url(Subdomain.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Subdomain" do
        expect {
          post subdomains_url, params: { subdomain: invalid_attributes }
        }.to change(Subdomain, :count).by(0)
      end

      it "renders a successful response (i.e. to display the 'new' template)" do
        post subdomains_url, params: { subdomain: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested subdomain" do
        subdomain = Subdomain.create! valid_attributes
        patch subdomain_url(subdomain), params: { subdomain: new_attributes }
        subdomain.reload
        skip("Add assertions for updated state")
      end

      it "redirects to the subdomain" do
        subdomain = Subdomain.create! valid_attributes
        patch subdomain_url(subdomain), params: { subdomain: new_attributes }
        subdomain.reload
        expect(response).to redirect_to(subdomain_url(subdomain))
      end
    end

    context "with invalid parameters" do
      it "renders a successful response (i.e. to display the 'edit' template)" do
        subdomain = Subdomain.create! valid_attributes
        patch subdomain_url(subdomain), params: { subdomain: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested subdomain" do
      subdomain = Subdomain.create! valid_attributes
      expect {
        delete subdomain_url(subdomain)
      }.to change(Subdomain, :count).by(-1)
    end

    it "redirects to the subdomains list" do
      subdomain = Subdomain.create! valid_attributes
      delete subdomain_url(subdomain)
      expect(response).to redirect_to(subdomains_url)
    end
  end
end