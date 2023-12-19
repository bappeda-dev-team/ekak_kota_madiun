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

RSpec.describe "/indikators_users", type: :request do
  # This should return the minimal set of attributes required to create a valid
  # IndikatorsUser. As you add validations to IndikatorsUser, be sure to
  # adjust the attributes here as well.
  let(:user) { create(:eselon_4) }
  let(:valid_attributes) do
    indikator = create(:indikator)
    {
      indikator_id: indikator.id,
      user_id: user.id
    }
  end

  let(:invalid_attributes) do
    {
      indikator_id: '',
      user_id: ''
    }
  end

  before(:each) do
    sign_in user
  end

  describe "GET /index" do
    it "renders a successful response" do
      IndikatorsUser.create! valid_attributes
      get indikators_users_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      indikators_user = IndikatorsUser.create! valid_attributes
      get indikators_user_url(indikators_user)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_indikators_user_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      indikators_user = IndikatorsUser.create! valid_attributes
      get edit_indikators_user_url(indikators_user)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new IndikatorsUser" do
        expect do
          post indikators_users_url, params: { indikators_user: valid_attributes }
        end.to change(IndikatorsUser, :count).by(1)
      end

      it "redirects to the created indikators_user" do
        post indikators_users_url, params: { indikators_user: valid_attributes }
        expect(response).to redirect_to(indikators_user_url(IndikatorsUser.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new IndikatorsUser" do
        expect do
          post indikators_users_url, params: { indikators_user: invalid_attributes }
        end.to change(IndikatorsUser, :count).by(0)
      end

      it "renders a successful response (i.e. to display the 'new' template)" do
        post indikators_users_url, params: { indikators_user: invalid_attributes }
        expect(response).to render_template(:new)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) do
        indikator_new = create(:indikator, indikator: 'test_new')
        {
          indikator_id: indikator_new.id
        }
      end

      it "updates the requested indikators_user" do
        indikators_user = IndikatorsUser.create! valid_attributes
        patch indikators_user_url(indikators_user), params: { indikators_user: new_attributes }
        indikators_user.reload
        expect(user.indikators.pluck(:indikator)).to include('test_new')
      end

      it "redirects to the indikators_user" do
        indikators_user = IndikatorsUser.create! valid_attributes
        patch indikators_user_url(indikators_user), params: { indikators_user: new_attributes }
        indikators_user.reload
        expect(response).to redirect_to(indikators_user_url(indikators_user))
      end
    end

    context "with invalid parameters" do
      it "renders a successful response (i.e. to display the 'edit' template)" do
        indikators_user = IndikatorsUser.create! valid_attributes
        patch indikators_user_url(indikators_user), params: { indikators_user: invalid_attributes }
        expect(response).to render_template(:edit)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested indikators_user" do
      indikators_user = IndikatorsUser.create! valid_attributes
      expect do
        delete indikators_user_url(indikators_user)
      end.to change(IndikatorsUser, :count).by(-1)
    end

    it "redirects to the indikators_users list" do
      indikators_user = IndikatorsUser.create! valid_attributes
      delete indikators_user_url(indikators_user)
      expect(response).to redirect_to(indikators_users_url)
    end
  end
end
