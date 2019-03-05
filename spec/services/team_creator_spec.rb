# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TeamCreator do
  describe '.call' do
    let(:user) { create(:user) }

    context 'when valid_params' do
      let(:valid_params) { { name: 'Team First' } }

      it 'creates new team' do
        expect { described_class.call(valid_params, user) }.to change { user.teams.count }.by 1
      end

      it 'creates 1 new user user_team' do
        expect { described_class.call(valid_params, user) }.to change { user.user_teams.count }.by 1
      end

      it "creates new user user_team with role  == 'creator'" do
        team = described_class.call(valid_params, user)
        expect(user.user_teams.find_by(team_id: team.id).roles[0]).to eq 'creator'
      end
    end
  end
end
