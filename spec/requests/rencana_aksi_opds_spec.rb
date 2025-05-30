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

RSpec.describe "/rencana_aksi_opds", type: :request do
  
  # This should return the minimal set of attributes required to create a valid
  # RencanaAksiOpd. As you add validations to RencanaAksiOpd, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  describe "GET /index" do
    it "renders a successful response" do
      RencanaAksiOpd.create! valid_attributes
      get rencana_aksi_opds_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      rencana_aksi_opd = RencanaAksiOpd.create! valid_attributes
      get rencana_aksi_opd_url(rencana_aksi_opd)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_rencana_aksi_opd_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      rencana_aksi_opd = RencanaAksiOpd.create! valid_attributes
      get edit_rencana_aksi_opd_url(rencana_aksi_opd)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new RencanaAksiOpd" do
        expect {
          post rencana_aksi_opds_url, params: { rencana_aksi_opd: valid_attributes }
        }.to change(RencanaAksiOpd, :count).by(1)
      end

      it "redirects to the created rencana_aksi_opd" do
        post rencana_aksi_opds_url, params: { rencana_aksi_opd: valid_attributes }
        expect(response).to redirect_to(rencana_aksi_opd_url(RencanaAksiOpd.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new RencanaAksiOpd" do
        expect {
          post rencana_aksi_opds_url, params: { rencana_aksi_opd: invalid_attributes }
        }.to change(RencanaAksiOpd, :count).by(0)
      end

    
      it "renders a successful response (i.e. to display the 'new' template)" do
        post rencana_aksi_opds_url, params: { rencana_aksi_opd: invalid_attributes }
        expect(response).to be_successful
      end
    
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested rencana_aksi_opd" do
        rencana_aksi_opd = RencanaAksiOpd.create! valid_attributes
        patch rencana_aksi_opd_url(rencana_aksi_opd), params: { rencana_aksi_opd: new_attributes }
        rencana_aksi_opd.reload
        skip("Add assertions for updated state")
      end

      it "redirects to the rencana_aksi_opd" do
        rencana_aksi_opd = RencanaAksiOpd.create! valid_attributes
        patch rencana_aksi_opd_url(rencana_aksi_opd), params: { rencana_aksi_opd: new_attributes }
        rencana_aksi_opd.reload
        expect(response).to redirect_to(rencana_aksi_opd_url(rencana_aksi_opd))
      end
    end

    context "with invalid parameters" do
    
      it "renders a successful response (i.e. to display the 'edit' template)" do
        rencana_aksi_opd = RencanaAksiOpd.create! valid_attributes
        patch rencana_aksi_opd_url(rencana_aksi_opd), params: { rencana_aksi_opd: invalid_attributes }
        expect(response).to be_successful
      end
    
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested rencana_aksi_opd" do
      rencana_aksi_opd = RencanaAksiOpd.create! valid_attributes
      expect {
        delete rencana_aksi_opd_url(rencana_aksi_opd)
      }.to change(RencanaAksiOpd, :count).by(-1)
    end

    it "redirects to the rencana_aksi_opds list" do
      rencana_aksi_opd = RencanaAksiOpd.create! valid_attributes
      delete rencana_aksi_opd_url(rencana_aksi_opd)
      expect(response).to redirect_to(rencana_aksi_opds_url)
    end
  end
end
