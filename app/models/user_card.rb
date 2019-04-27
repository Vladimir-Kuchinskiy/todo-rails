# frozen_string_literal: true

class UserCard < ApplicationRecord
  belongs_to :card
  belongs_to :user

  delegate :email, to: :user, prefix: true
end
