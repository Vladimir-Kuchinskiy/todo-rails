# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BraintreePayment, type: :model do
  it { is_expected.to belong_to(:user) }

  it { is_expected.to validate_presence_of(:payment_method_token) }
  it { is_expected.to validate_presence_of(:customer_id) }
end
