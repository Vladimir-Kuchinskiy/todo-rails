# frozen_string_literal: true

class Subscription < ApplicationRecord
  before_create :set_expires_at

  AMOUNT = 5
  belongs_to :user

  def expired?
    expires_at < Time.current
  end

  def expires_at_formatted
    expires_at.strftime('%d/%m/%Y')
  end

  private

  def set_expires_at
    self.expires_at = Time.current + 1.month
  end
end
