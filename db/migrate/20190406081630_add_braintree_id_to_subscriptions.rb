# frozen_string_literal: true

class AddBraintreeIdToSubscriptions < ActiveRecord::Migration[5.2]
  def change
    add_column :subscriptions, :braintree_id, :string
  end
end
