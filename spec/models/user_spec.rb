# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it { is_expected.to have_one(:profile).dependent(:destroy) }
  it { is_expected.to have_one(:subscription).dependent(:destroy) }
  it { is_expected.to have_one(:braintree_payment).dependent(:destroy) }

  it { is_expected.to have_many(:boards) }
  it { is_expected.to have_many(:user_teams).dependent(:destroy) }
  it { is_expected.to have_many(:teams).through(:user_teams) }
  it { is_expected.to have_many(:invitations).with_foreign_key('creator_id') }
  it { is_expected.to have_many(:received_invitations).with_foreign_key('receiver_id') }

  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_presence_of(:password) }
  it { is_expected.to validate_uniqueness_of(:email) }
  it { is_expected.to validate_length_of(:password).is_at_least(8) }

  describe '#create_invitation' do
    let!(:user) { create(:user) }

    context 'with valid params' do
      it 'creates a new invitation' do
        receiver = create(:user)
        team = create(:user_team, user_id: user.id, team: create(:team), roles: ['creator']).team
        valid_params = { receiver_email: receiver.email, team_id: team.id }
        expect { user.create_invitation(valid_params) }.to change { user.invitations.count }.by 1
      end
    end

    context 'with invalid params' do
      it 'raises RecordNotFound exception' do
        invalid_params = {}
        expect { user.create_invitation(invalid_params) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe '#member?' do
    let(:user) { create(:user) }

    context 'when user is a member' do
      let!(:subscription) { create(:subscription, user_id: user.id) }

      context 'when subscription is expired' do
        before { subscription.update(expires_at: Time.current - 1.hour, status: Subscription::STATUSES[:canceled]) }

        it 'destroys a subscription' do
          expect { user.member? }.to change { Subscription.count }.by(-1)
        end

        it 'returns false' do
          expect(user.member?).to eq false
        end
      end

      context 'when subscription is not expired' do
        it 'returns true' do
          expect(user.member?).to eq true
        end
      end
    end

    context 'when user is not a member' do
      it 'returns false' do
        expect(user.member?).to eq false
      end
    end
  end

  describe '#boards_limit_raised?' do
    let(:user) { create(:user) }

    context 'for personal board' do
      context "boards count is >= #{described_class::BOARDS_LIMIT}" do
        it 'returns true' do
          create_list(:board, described_class::BOARDS_LIMIT, user_id: user.id)
          expect(user.boards_limit_raised?).to eq true
        end
      end

      context "boards count is < #{described_class::BOARDS_LIMIT}" do
        it 'returns false' do
          expect(user.boards_limit_raised?).to eq false
        end
      end
    end

    context 'for team board' do
      let(:team) { create(:user_team, user_id: user.id, team_id: create(:team).id, roles: ['creator']).team }

      context "boards count is >= #{described_class::BOARDS_LIMIT}" do
        it 'returns true' do
          create_list(:board, described_class::BOARDS_LIMIT, user_id: user.id, team_id: team.id)
          expect(user.boards_limit_raised?(team.id)).to eq true
        end
      end

      context "boards count is < #{described_class::BOARDS_LIMIT}" do
        it 'returns false' do
          expect(user.boards_limit_raised?(team.id)).to eq false
        end
      end
    end
  end

  describe '#invited?' do
    let(:user) { create(:user) }
    let(:team) { create(:user_team, user_id: create(:user).id, team_id: create(:team).id, roles: ['creator']).team }

    context 'when user is invited to amy team' do
      it 'returns true' do
        create(:invitation, receiver_id: user.id, creator_id: create(:user).id, team_id: team.id)
        expect(user.invited?(team)).to eq true
      end
    end

    context 'when user is not invited to any team' do
      it 'returns false' do
        expect(user.invited?(team)).to eq false
      end
    end
  end

  describe '#create_subscription' do
    it 'creates subscription' do
      user = create(:user)
      expect { user.create_subscription('fake_id') }.to change { Subscription.count }.by(1)
    end
  end
end
