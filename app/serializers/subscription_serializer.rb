# frozen_string_literal: true

class SubscriptionSerializer
  include FastJsonapi::ObjectSerializer
  set_key_transform :camel_lower

  attributes :status

  attribute :expires_at do |subscription|
    subscription.formatted_date_time(subscription.expires_at)
  end

  attribute :bought_at do |subscription|
    subscription.formatted_date_time(subscription.created_at)
  end

  attribute :amount do
    Subscription::AMOUNT
  end
end
