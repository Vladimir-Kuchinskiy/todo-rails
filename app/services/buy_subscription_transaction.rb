# frozen_string_literal: true

class BuySubscriptionTransaction
  def initialize(params, current_user)
    @gateway = new_braintree_gateway
    @nonce = params[:nonce]
    @current_user = current_user
  end

  def generate_token
    return gateway.client_token.generate unless current_user.payment_info?

    gateway.client_token.generate(customer_id: current_user.braintree_payment.customer_id)
  end

  def sale_subscription
    raise ExceptionHandler::PaymentError, Message.already_has_membership if current_user.member?

    result = gateway_sale
    raise ExceptionHandler::PaymentError, Message.payment_error unless result.success?

    current_user.create_subscription(result.subscription.id)
  end

  def cancel_subscription(braintree_subscription_id)
    gateway.subscription.cancel(braintree_subscription_id)
  end

  private

  attr_reader :gateway, :nonce, :current_user

  def gateway_sale
    create_braintree_customer unless current_user.payment_info?
    gateway.subscription.create(
      payment_method_token: current_user.braintree_payment.payment_method_token,
      plan_id: Subscription::PLANS[:standard]
    )
  end

  def create_braintree_customer
    result = gateway.customer.create(
      first_name: current_user.first_name,
      last_name: current_user.last_name,
      email: current_user.email,
      payment_method_nonce: nonce
    )
    create_user_braintree_payment_info(result.customer)
  end

  def create_user_braintree_payment_info(customer)
    BraintreePayment.create(
      customer_id: customer.id,
      payment_method_token: customer.payment_methods[0].token,
      user_id: current_user.id
    )
  end

  def new_braintree_gateway
    Braintree::Gateway.new(
      logger: Logger.new('log/braintree.log'),
      environment: :sandbox,
      merchant_id: ENV['BRAINTREE_MERCHANT_ID'],
      public_key: ENV['BRAINTREE_PUBLIC_KEY'],
      private_key: ENV['BRAINTREE_PRIVATE_KEY']
    )
  end
end
