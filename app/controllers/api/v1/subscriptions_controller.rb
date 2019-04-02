# frozen_string_literal: true

module Api
  module V1
    class SubscriptionsController < ApplicationController
      def index
        json_response(SubscriptionSerializer.new(current_user.subscription))
      end

      def new
        json_response(client_token: transaction.generate_token)
      end

      def create
        transaction.sale_subscription
        json_response(SubscriptionSerializer.new(
                        User.find(current_user.id).subscription,
                        params: { host_with_port: request.host_with_port }
                      ))
      end

      private

      def transaction
        @transaction ||= BuySubscriptionTransaction.new(params, current_user)
      end
    end
  end
end
