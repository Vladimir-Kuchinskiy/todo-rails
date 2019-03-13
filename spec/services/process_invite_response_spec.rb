# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProcessInviteResponse do
  describe '.call' do
    let(:creator) { create(:user) }
    let!(:team) { create(:user_team, user_id: creator.id, team: create(:team), roles: ['creator']).team }
    let(:receiver) { create(:user) }
    let!(:invitation) { create(:invitation, team_id: team.id, creator_id: creator.id, receiver_id: receiver.id) }

    context 'when valid_params' do
      context 'when desition is true' do
        let(:valid_params) { { id: invitation.id, desigion: true } }

        it 'adds a user to a team' do
          expect { described_class.call(valid_params) }.to change { team.users.reload.count }.by 1
        end

        it 'deletes invitation' do
          expect { described_class.call(valid_params) }.to change { Invitation.count }.by(-1)
        end

        it 'returns a deleted invitation' do
          expect(described_class.call(valid_params)).to eq invitation
        end
      end

      context 'when desition is false' do
        let(:valid_params) { { id: invitation.id, desigion: false } }

        it 'does not add a user to a team' do
          expect { described_class.call(valid_params) }.to change { team.users.reload.count }.by 0
        end

        it 'deletes invitation' do
          expect { described_class.call(valid_params) }.to change { Invitation.count }.by(-1)
        end

        it 'returns a deleted invitation' do
          expect(described_class.call(valid_params)).to eq invitation
        end
      end
    end
  end
end
