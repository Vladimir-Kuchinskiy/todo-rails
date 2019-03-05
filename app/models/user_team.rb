# frozen_string_literal: true

class UserTeam < ApplicationRecord
  before_validation :add_role_if_member

  ROLE_KINDS = %w[
    creator
    member
  ].freeze

  serialize :roles, Array

  validates :roles, presence: true

  belongs_to :user
  belongs_to :team

  def add_role(role)
    new_roles = roles.push(role).uniq
    self.roles = new_roles.select { |r| ROLE_KINDS.include?(r) }
  end

  private

  def add_role_if_member
    add_role('member') unless roles.any?
  end
end
