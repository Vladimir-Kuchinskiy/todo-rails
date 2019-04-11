# frozen_string_literal: true

class BraintreePayment < ApplicationRecord
  belongs_to :user

  validates :customer_id, :payment_method_token, presence: true
end
