# frozen_string_literal: true

module Api
  module V1
    class SubscriptionsController < ApplicationController
      before_action :set_subscription, only: :update

      def index
        json_response(SubscriptionSerializer.new(current_user.subscription))
      end

      def new
        json_response(client_token: transaction.generate_token)
      end

      def create
        transaction.sale_subscription
        json_response(SubscriptionSerializer.new(User.find(current_user.id).subscription))
      end

      def update
        transaction.cancel_subscription(@subscription.braintree_id)
        @subscription.cancel!
        json_response(SubscriptionSerializer.new(@subscription))
      end

      private

      def transaction
        @transaction ||= BuySubscriptionTransaction.new(params, current_user)
      end

      def set_subscription
        @subscription = Subscription.find_by!(id: params[:id], user_id: current_user.id)
      end
    end
  end
end
