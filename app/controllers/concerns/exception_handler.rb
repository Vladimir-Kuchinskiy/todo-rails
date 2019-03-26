# frozen_string_literal: true

module ExceptionHandler
  extend ActiveSupport::Concern

  class AuthenticationError < StandardError; end
  class MissingToken < StandardError; end
  class InvalidToken < StandardError; end
  class DeleteBoardAccessDenied < StandardError; end

  included do
    rescue_from ActiveRecord::RecordInvalid, with: :four_twenty_two
    rescue_from ActiveRecord::RecordNotUnique, with: :four_twenty_two
    rescue_from ExceptionHandler::AuthenticationError, with: :unauthorized_request
    rescue_from ExceptionHandler::DeleteBoardAccessDenied, with: :forbidden_request
    rescue_from ExceptionHandler::MissingToken, with: :four_twenty_two
    rescue_from ExceptionHandler::InvalidToken, with: :four_twenty_two

    rescue_from ActiveRecord::RecordNotFound do |e|
      json_response({ message: e.message }, :not_found)
    end

    rescue_from MoveParamsValidator::InvalidMoveParamsError do |e|
      json_response({ message: e.message }, :bad_request)
    end
  end

  private

  def four_twenty_two(error)
    json_response({ message: error.message }, :unprocessable_entity)
  end

  def unauthorized_request(error)
    json_response({ message: error.message }, :unauthorized)
  end

  def forbidden_request(error)
    json_response({ message: error.message }, :forbidden)
  end
end
