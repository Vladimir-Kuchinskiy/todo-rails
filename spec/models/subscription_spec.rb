# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Subscription, type: :model do
  describe 'before_create' do
    context '#set_expires_at' do
      it 'should set expires when creating subscription' do
        subscription = create(:subscription)
        expect(subscription.expires_at.to_date).to eq(Time.current.to_date + 1.month)
      end
    end
  end

  describe '#expired?' do
    let(:subscription) { create(:subscription) }

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

  describe '#expires_at_formatted' do
    it 'returns expires_at datetime formatted like (%d/%m/%Y)' do
      subscription = create(:subscription)
      expect(subscription.expires_at_formatted).to eq subscription.expires_at.strftime('%d/%m/%Y')
    end
  end
end
