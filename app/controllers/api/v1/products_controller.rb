# frozen_string_literal: true

module Api
  module V1
    class ProductsController < ApplicationController
      before_action :authenticate_api_user!
      before_action :set_product, only: %i[show update destroy]
      before_action :check_user_access, only: %i[update destroy]
      before_action :validate_seller, only: [:create]

      # GET /api/v1/products
      def index
        @products = Product.all.order('created_at')

        render json: @products
      end

      # GET /api/v1/products/1
      def show
        render json: @product
      end

      # POST /api/v1/products
      def create
        @product = Product.new(product_params)

        if @product.save
          render json: @product, status: :created
        else
          render json: @product.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/products/1
      def update
        if @product.update(product_params)
          render json: @product
        else
          render json: @product.errors, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/products/1
      def destroy
        @product.destroy
        render json: { message: 'Product deleted successfully' }, status: :ok
      end

      # BUY /api/v1/products/buy
      def buy
        buyer = current_api_user
        product = Product.find(params[:product_id])
        quantity = params[:quantity].to_i
        total_cost = product.cost * quantity
        if product.amount_available.to_i < quantity
          render json: {
            error: 'Product is out of stock',
            status: :unprocessable_entity
          }
        elsif buyer.total_money_deposited < total_cost
          render json: {
            error: "Don't have sufficient deposit amount",
            status: :unprocessable_entity
          }
        else
          change_hash = {}
          change_hash[:deposit] = BuyProduct.run(buyer, product, total_cost, quantity).to_json

          render json: {
            total_spend: total_cost,
            products: product,
            change: JSON.parse(change_hash[:deposit]),
            status: :ok
          }
        end
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_product
        @product = Product.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def product_params
        params.require(:product).permit(:product_name, :cost, :amount_available, :seller_id)
      end

      def check_user_access
        return if current_api_user.id == @product.seller_id

        render json: {
          error: "Seller doesn't have access to update this product",
          status: :unprocessable_entity
        }
      end

      def validate_seller
        return if current_api_user.seller?

        render json: {
          error: 'Only seller can create the products',
          status: :unprocessable_entity
        }
      end
    end
  end
end
