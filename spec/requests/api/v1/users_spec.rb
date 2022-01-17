require 'rails_helper'

RSpec.describe "/api/v1/users", type: :request do
  let!(:user) { create(:user) }

  before(:each) do
    sign_in user
  end

  let(:valid_headers) { user.create_new_auth_token }

  describe "GET /index (/api/v1/users)" do
    it "renders a successful response" do
      get api_v1_users_url, headers: valid_headers, as: :json
      expect(response).to be_successful
      expect(response.content_type).to eq("application/json; charset=utf-8")
    end
  end

  describe "GET /show (/api/v1/users/:id)" do
    it "renders a successful response" do
      get api_v1_user_url(user), headers: valid_headers, as: :json
      expect(response).to be_successful
      expect(response.content_type).to eq("application/json; charset=utf-8")
    end
  end

  describe "PATCH /update (/api/v1/users/:id)" do
    context "with valid parameters" do
      let(:new_attributes) do
        {
          deposit: 2000
        }
      end

      it "renders a JSON response with the api/v1_user" do
        patch api_v1_user_url(user), params: { user: new_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end
  end

  describe 'PUT /deposit (/api/v1/users/:id/deposit)' do
    context 'Only buyer user can deposit' do
      let!(:user) { create(:user, role: :buyer) }
      let(:valid_headers) { user.create_new_auth_token }

      let(:deposit_params) do
        {
          deposit: { 'cent5': '10', 'cent10': '10', 'cent20': '10', 'cent50': '1', 'cent100': '10' }.to_json
        }
      end

      it 'successfully deposit amount' do
        put api_v1_user_deposit_url(user), params: { user: deposit_params }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:ok)
      end
    end

    context 'Seller user cannot deposit' do
      # For rspec default user is seller
      let(:deposit_params) do
        {
          deposit: { 'cent5': '10', 'cent10': '10', 'cent20': '10', 'cent50': '1', 'cent100': '10' }.to_json
        }
      end

      it 'successfully deposit amount' do
        put api_v1_user_deposit_url(user), params: { user: deposit_params }, headers: valid_headers, as: :json

        expect(JSON.parse(response.body)['status']).to eq 'unprocessable_entity'
        expect(JSON.parse(response.body)['error']).to eq 'Only buyer can deposit/reset money'
      end
    end
  end

  describe 'PUT /reset_deposit (/api/v1/users/:id/reset_deposit)' do
    context 'Only buyer user can reset_deposit' do
      let!(:user) { create(:user, role: :buyer) }
      let(:valid_headers) { user.create_new_auth_token }

      it 'successfully reset deposit amount' do
        put api_v1_user_reset_deposit_url(user), headers: valid_headers, as: :json
        expect(response).to have_http_status(:ok)
      end
    end

    context 'Seller user cannot deposit and' do
      # For rspec default user is seller
      it 'fails to reset deposit amount' do
        put api_v1_user_reset_deposit_url(user), headers: valid_headers, as: :json

        expect(JSON.parse(response.body)['status']).to eq 'unprocessable_entity'
        expect(JSON.parse(response.body)['error']).to eq 'Only buyer can deposit/reset money'
      end
    end
  end
end
