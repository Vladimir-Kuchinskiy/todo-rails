# frozen_string_literal: true

class Subscription < ApplicationRecord
  before_validation :set_expires_at, :set_status

  validates :expires_at, :status, presence: true

  AMOUNT = 5
  PLANS = { standard: 'standard_plan' }.freeze
  STATUSES = { active: 'Active', canceled: 'Canceled' }.freeze
  belongs_to :user

  def formatted_date_time(date)
    date.strftime('%d/%m/%Y %r')
  end

  def cancel!
    update(status: STATUSES[:canceled], expires_at: subscription_end_date)
  end

  def expired?
    expires_at < Time.current
  end

  def active?
    status == STATUSES[:active]
  end

  def canceled?
    status == STATUSES[:canceled]
  end

  private

  def set_expires_at
    self.expires_at ||= Time.current + 1.month
  end

  def set_status
    self.status ||= STATUSES[:active]
  end

  def subscription_end_date
    today = Time.current
    expire_month = today.month + (expires_at.day < today.day ? 1 : 0)
    Time.new(today.year, expire_month) + expires_at.day.days
  end
end
