# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it { is_expected.to have_many(:boards) }
  it { is_expected.to have_many(:user_teams) }
  it { is_expected.to have_many(:teams).through(:user_teams) }

  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_presence_of(:password) }
  it { is_expected.to validate_uniqueness_of(:email) }
  it { is_expected.to validate_length_of(:password).is_at_least(8) }

  describe '#profile' do
    it 'returns hash with user email' do
      user = create(:user)
      expect(user.profile[:email]).to eq user.email
    end
  end
end
