# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Invitation, type: :model do
  it { is_expected.to belong_to(:creator).class_name('User') }
  it { is_expected.to belong_to(:receiver).class_name('User') }
  it { is_expected.to belong_to(:team) }
end
