# frozen_string_literal: true

module Api
  class ApplicationController < ::ApplicationController
    include ::Response
    include ::ExceptionHandler

    before_action :authorize_request
    attr_reader :current_user

    private

    def authorize_request
      @current_user = AuthorizeApiRequest.new(request.headers).call[:user]
    end
  end
end
