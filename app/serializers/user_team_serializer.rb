# frozen_string_literal: true

class UserTeamSerializer
  include FastJsonapi::ObjectSerializer
  attributes :roles, :user_id
end
