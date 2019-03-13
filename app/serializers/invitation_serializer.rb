# frozen_string_literal: true

class InvitationSerializer
  include FastJsonapi::ObjectSerializer
  set_key_transform :camel_lower

  belongs_to :team

  attributes :team_name

  attribute :inviter_email, &:creator_email
end
