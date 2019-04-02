# frozen_string_literal: true

class BuySubscriptionTransaction
  def initialize(params, current_user)
    @gateway = Braintree::Gateway.new(
      logger: Logger.new('log/braintree.log'),
      environment: :sandbox,
      merchant_id: ENV['BRAINTREE_MERCHANT_ID'],
      public_key: ENV['BRAINTREE_PUBLIC_KEY'],
      private_key: ENV['BRAINTREE_PRIVATE_KEY']
    )
    @nonce = params[:nonce]
    @current_user = current_user
  end

  def generate_token
    gateway.client_token.generate
  end

  def sale_subscription
    raise ExceptionHandler::PaymentError, Message.already_has_membership if current_user.member?

    result = gateway_sale
    raise ExceptionHandler::PaymentError, Message.payment_error unless result.success?

    current_user.create_subscription
  end

  private

  def gateway_sale
    gateway.transaction.sale(
      amount: Subscription::AMOUNT,
      payment_method_nonce: nonce,
      options: { submit_for_settlement: true }
    )
  end

  attr_reader :gateway, :nonce, :current_user
end
