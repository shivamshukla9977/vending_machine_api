# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      before_action :authenticate_api_user!
      before_action :set_user, only: %i[show update destroy]
      before_action :validate_buyer, only: %i[deposit reset_deposit]

      # GET /api/v1/users
      def index
        @users = User.all

        render json: @users
      end

      # GET /api/v1/users/1
      def show
        render json: @user
      end

      # PATCH/PUT /api/v1/users/1
      def update
        if @user.update(user_params)
          render json: @user
        else
          render json: @user.errors, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/users/1
      def destroy
        @user.destroy
        render json: { message: 'User deleted successfully' }, status: :ok
      end

      def deposit
        @user = User.find(params[:user_id])
        deposit_coins = @user.update_coins(deposit_params)
        if @user.update(deposit_coins)
          render json: @user
        else
          render json: @user.errors, status: :unprocessable_entity
        end
      end

      def reset_deposit
        @user = User.find(params[:user_id])
        if @user.reset_deposit
          render json: @user
        else
          render json: @user.errors, status: :unprocessable_entity
        end
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_user
        @user = User.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def user_params
        params.require(:user).permit(:username, :email, :role)
      end

      def deposit_params
        params.require(:user).permit(:deposit)
      end

      def validate_buyer
        return if current_api_user.buyer?

        render json: {
          error: 'Only buyer can deposit/reset money',
          status: :unprocessable_entity
        }
      end
    end
  end
end
