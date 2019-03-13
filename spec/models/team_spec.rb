# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Team, type: :model do
  it { is_expected.to have_many(:boards).dependent(:nullify) }
  it { is_expected.to have_many(:user_teams) }
  it { is_expected.to have_many(:users).through(:user_teams) }
  it { is_expected.to have_many(:invitations).dependent(:destroy) }

  it { is_expected.to validate_presence_of(:name) }

  describe '#emails_of_users_not_in_the_team' do
    let(:team) { create(:team) }

    before { create_list(:user_team, 4, team_id: team.id) }

    context 'when team has all users' do
      it 'returns empty array' do
        expect(team.emails_of_users_not_in_the_team).to eq []
      end
    end

    context 'when team has a half of users' do
      it 'returns an array of length of not member users' do
        not_members = create_list(:user, 4)
        expect(team.emails_of_users_not_in_the_team.size).to eq not_members.size
      end
    end

    context 'when team has no users' do
      it 'returns an array of emails of no member users' do
        new_team = create(:team)
        expect(new_team.emails_of_users_not_in_the_team).to eq(User.all.map do |user|
          { email: user.email, is_invited: user.invited?(new_team) }
        end)
      end
    end
  end
end
