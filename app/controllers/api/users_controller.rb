# frozen_string_literal: true

module Api
  class UsersController < ApplicationController
    skip_before_action :authorize_request, only: :create

    def create
      user = User.new(user_params)
      if user.save
        auth_token = AuthenticateUser.new(user.email, user.password).call
        response = { message: Message.account_created, auth_token: auth_token }
        json_response(response, :created)
      else
        json_response({ errors: user.errors.messages }, :unprocessable_entity)
      end
    end

    private

    def user_params
      params.permit(:email, :password, :password_confirmation)
    end
  end
end
