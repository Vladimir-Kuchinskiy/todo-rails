# frozen_string_literal: true

class SubscriptionSerializer
  include FastJsonapi::ObjectSerializer
  set_key_transform :camel_lower

  attribute :expires_at, &:expires_at_formated

  attribute :amount do
    Subscription::AMOUNT
  end
end
