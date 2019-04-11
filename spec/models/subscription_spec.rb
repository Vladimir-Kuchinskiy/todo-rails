# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Subscription, type: :model do
  it { is_expected.to belong_to(:user) }

  let(:subscription) { create(:subscription) }

  describe 'before_validation' do
    context '#set_expires_at' do
      it 'should set expires when creating subscription' do
        expect(subscription.expires_at.to_date).to eq(Time.current.to_date + 1.month)
      end
    end
  end

  describe '#expired?' do
    context 'when subscription is expired' do
      it 'returns true' do
        subscription.update(expires_at: Time.current - 1.hour)
        expect(subscription.expired?).to eq true
      end
    end

    context 'when subscription is not expired' do
      it 'returns true' do
        expect(subscription.expired?).to eq false
      end
    end
  end

  describe '#formatted_date_time' do
    it 'returns datetime formatted like (%d/%m/%Y %r)' do
      expect(
        subscription.formatted_date_time(subscription.expires_at)
      ).to eq subscription.expires_at.strftime('%d/%m/%Y %r')
    end
  end

  describe '#cancel!' do
    it 'updates subscription status to Subscription::STATUSES[:canceled]' do
      subscription.cancel!
      expect(subscription.status).to eq Subscription::STATUSES[:canceled]
    end

    it 'updates subscription expires_at datetime' do
      today = Time.current
      expire_month = today.month + (subscription.expires_at.day < today.day ? 1 : 0)
      expire_datetime = Time.new(today.year, expire_month) + subscription.expires_at.day.days
      subscription.cancel!
      expect(subscription.expires_at).to eq expire_datetime
    end
  end
end
