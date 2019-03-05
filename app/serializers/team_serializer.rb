# frozen_string_literal: true

class TeamSerializer
  include FastJsonapi::ObjectSerializer
  set_key_transform :camel_lower

  has_many :boards
  has_many :users

  attributes :name
  attribute :user_emails, &:emails_of_users_not_in_the_team
end
