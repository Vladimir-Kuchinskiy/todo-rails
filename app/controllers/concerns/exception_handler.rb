# frozen_string_literal: true

module ExceptionHandler
  extend ActiveSupport::Concern

  class AuthenticationError < StandardError; end
  class MissingToken        < StandardError; end
  class InvalidToken        < StandardError; end
  class BoardAccessDenied   < StandardError; end
  class PaymentError        < StandardError; end
  class NoMemberError       < StandardError; end
  class AssignError         < StandardError; end

  included do
    rescue_from ExceptionHandler::AuthenticationError, with: :unauthorized_request
    rescue_from ExceptionHandler::BoardAccessDenied,   with: :forbidden_request
    rescue_from ExceptionHandler::NoMemberError,       with: :forbidden_request
    rescue_from ActiveRecord::RecordInvalid,           with: :four_twenty_two
    rescue_from ActiveRecord::RecordNotUnique,         with: :four_twenty_two
    rescue_from ExceptionHandler::MissingToken,        with: :four_twenty_two
    rescue_from ExceptionHandler::InvalidToken,        with: :four_twenty_two
    rescue_from ExceptionHandler::PaymentError,        with: :four_twenty_two

    rescue_from ActiveRecord::RecordNotFound do |e|
      json_response({ message: e.message }, :not_found)
    end

    rescue_from MoveParamsValidator::InvalidMoveParamsError,
                ExceptionHandler::AssignError do |e|
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
