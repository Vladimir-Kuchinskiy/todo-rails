# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserTeam, type: :model do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:team) }
end
