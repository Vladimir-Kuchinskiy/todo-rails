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
      'Sorry, your token has expired. Please login to continue.'
    end

    def board_not_allowed
      'Sorry, you can not create/update/delete a board, because you are not a creator of a team'
    end
  end
end
