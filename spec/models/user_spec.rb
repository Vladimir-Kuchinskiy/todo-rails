# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it { is_expected.to have_one(:profile).dependent(:destroy) }

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
end
