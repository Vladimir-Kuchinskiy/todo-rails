# frozen_string_literal: true

class TeamSerializer
  include FastJsonapi::ObjectSerializer
  set_key_transform :camel_lower

  has_many :boards
  has_many :users
  has_many :user_teams

  attributes :name
  attribute :user_emails, &:emails_of_users_not_in_the_team
  attribute :creator_email do |team|
    team.creator.email
  end
end
