require 'rails_helper'

RSpec.describe "/api/v1/products", type: :request do
  let!(:user) { create(:user) }
  let!(:product) { create(:product, seller_id: user.id) }
  let(:valid_headers) { user.create_new_auth_token }

  describe "GET /index" do
    it "renders a successful response" do
      get api_v1_products_url, headers: valid_headers, as: :json
      expect(response).to be_successful
      expect(response.content_type).to eq("application/json; charset=utf-8")
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      get api_v1_product_url(product), headers: valid_headers, as: :json
      expect(response).to be_successful
      expect(response.content_type).to eq("application/json; charset=utf-8")
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      let(:valid_attributes) do
        {
          amount_available: Faker::Number.within(range: 1..1000),
          cost: Faker::Number.within(range: 1..10),
          product_name: Faker::Name.unique.name,
          seller_id: user.id
        }
      end

      it "creates a new Product" do
        expect {
          post api_v1_products_url,
               params: { product: valid_attributes }, headers: valid_headers, as: :json
        }.to change(Product, :count).by(1)
      end

      it "renders a JSON response with the new product" do
        post api_v1_products_url,
             params: { product: valid_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        {
          amount_available: "10",
        }
      }

      it "updates the requested product" do
        patch api_v1_product_url(product),
              params: { product: new_attributes }, headers: valid_headers, as: :json
        product.reload
        expect(product.amount_available).to match("10")
      end

      it "renders a JSON response with the product" do
        patch api_v1_product_url(product),
              params: { product: new_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested product" do
      expect {
        delete api_v1_product_url(product), headers: valid_headers, as: :json
      }.to change(Product, :count).by(-1)
    end
  end
end
