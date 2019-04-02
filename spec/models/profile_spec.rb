# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Profile, type: :model do
  it { is_expected.to belong_to(:user) }

  describe '#member?' do
    let(:profile) { create(:profile) }
    context 'when profile user is a member' do
      it 'returns true' do
        Subscription.create(user_id: profile.user.id)
        expect(profile.member?).to eq true
      end
    end
    context 'when profile user is not a member' do
      it 'returns false' do
        expect(profile.member?).to eq false
      end
    end
  end
end
