# frozen_string_literal: true

class CreateBraintreePayments < ActiveRecord::Migration[5.2]
  def change
    create_table :braintree_payments do |t|
      t.string :customer_id
      t.string :payment_method_token
      t.belongs_to :user, index: true

      t.timestamps
    end
  end
end
