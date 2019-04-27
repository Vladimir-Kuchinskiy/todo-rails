# frozen_string_literal: true

class Message
  class << self
    def not_found(record = 'record')
      "Sorry, #{record} not found."
    end

    def invalid_credentials
      'Invalid credentials'
    end

    def invalid_token
      'Invalid token'
    end

    def missing_token
      'Missing token'
    end

    def unauthorized
      'Unauthorized request'
    end

    def account_created
      'Account created successfully'
    end

    def account_not_created
      'Account could not be created'
    end

    def expired_token
      'Sorry, your token has expired. Please login to continue'
    end

    def board_not_allowed
      'Sorry, you can not create/update/delete a board, because you are not a creator of a team'
    end

    def payment_error
      'Sorry, there was some errors during payment'
    end

    def already_has_membership
      'You are already a member'
    end

    def not_member_board
      "Sorry, but you need to become a member to create more then #{User::BOARDS_LIMIT} boards"
    end

    def no_member_board
      'Sorry, but you need to become a member to create your own teams'
    end

    def not_a_board_member
      'Not a board member'
    end

    def user_is_not_team_member
      'Assign user is not a team member'
    end
  end
end
